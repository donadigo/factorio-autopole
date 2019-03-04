require 'pathfinder'
require 'utils'

local TILE_REACH = {}
TILE_REACH["small-electric-pole"] = 7.5
TILE_REACH["medium-electric-pole"] = 9
TILE_REACH["big-electric-pole"] = 30

local requests = {}

function on_built(e)
    if e.stack.name == "blueprint" then return end

    local ent = e.created_entity
    if ent.name == "entity-ghost" and (ent.ghost_name == "small-electric-pole" or
        ent.ghost_name == "big-electric-pole" or
        ent.ghost_name == 'medium-electric-pole') then
        local remote = utils.find_closest_pole(game.players[e.player_index], ent)
        if remote ~= nil then
            local start = remote.position

            -- If the closest pole is not the size of the placed one
            -- place the target pole size near the closest.
            -- Do this when the path is known
            if remote.name ~= ent.ghost_name then
                local surface = ent.surface
                local bounds = remote.bounding_box
                bounds.left_top.x = bounds.left_top.x - (TILE_REACH[remote.name] - TILE_REACH[ent.ghost_name])
                bounds.left_top.y = bounds.left_top.y + (TILE_REACH[remote.name] - TILE_REACH[ent.ghost_name])
                bounds.right_bottom.x = bounds.right_bottom.x + (TILE_REACH[remote.name] - TILE_REACH[ent.ghost_name])
                bounds.right_bottom.y = bounds.right_bottom.y - (TILE_REACH[remote.name] - TILE_REACH[ent.ghost_name])

                start = surface.find_non_colliding_position_in_box(remote.name, bounds, 1, true)
                surface.create_entity{
                    name=ent.ghost_name,
                    position=start, player=game.players[e.player_index],
                    force=game.players[e.player_index].force
                }
            end

            local request = pathfinder.partial_a_star(ent.surface, remote.position, ent.position, 100, 10000)
            request.remote = remote
            request.ent = ent
            request.player_index = e.player_index
            if request.completed then
                complete_poles(request)
            else
                table.insert(requests, request)
            end
        end
    end
end

function complete_poles(request)
    local path = request.path

    local prev_pos = nil
    local current_pole = request.remote
    local ent = request.ent
    local player = game.players[request.player_index]

    if path ~= nil then
        for i, wp in pairs(path) do
            if player.get_item_count(ent.ghost_name) == 0 then return end

            if utils.euclidean(wp.x + 0.5, wp.y + 0.5, current_pole.position.x, current_pole.position.y) >= TILE_REACH[ent.ghost_name] then
                current_pole = ent.surface.create_entity{
                    name=ent.ghost_name,
                    position=prev_pos, player=player,
                    force=player.force
                }

                player.remove_item({ name = ent.ghost_name, count = 1 })
            end 

            prev_pos = wp
        end

        if player.get_item_count(ent.ghost_name) == 0 then return end
        if ent.valid then
            player.remove_item({ name = ent.ghost_name, count = 1 })
            ent.revive()
        end
    end
end

function on_tick(e)
    if next(requests) ~= nil then
        for i, request in pairs(requests) do
            if request.completed then
                complete_poles(request)
                requests[i] = nil
            else
                local remote = request.remote
                local ent = request.ent
                local player_index = request.player_index
                request = pathfinder.resume_a_star(request, 100)
                request.remote = remote
                request.ent = ent
                request.player_index = player_index
                requests[i] = request
            end
        end
    end
end

script.on_event({defines.events.on_built_entity}, on_built)
script.on_event({defines.events.on_tick}, on_tick)