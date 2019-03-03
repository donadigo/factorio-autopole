function on_path_request_finished(e)
    if e.id == current_request.id then
        local path = e.path
        
        if path ~= nil then
            local placed = current_request.placed
            local surface = game.surfaces[1]

            local prev_pos = nil
            local current_pole = current_request.remote
            
            local radius = current_request.radius        
            for i, wp in pairs(path) do
                if game.players[1].get_item_count(placed.ghost_name) == 0 then
                    break
                end

                if surface.can_place_entity{name = placed.ghost_name, position = wp.position, force = game.players[1].force} then

                -- if euclidean(wp.position.x, wp.position.y, current_pole.position.x, current_pole.position.y) > TILE_REACH[placed.ghost_name] then
                    current_pole = surface.create_entity{
                        name=placed.ghost_name,
                        position=wp.position, player=game.players[1],
                        force=game.players[1].force
                    }

                    -- game.players[1].remove_item({
                    --     name=placed.ghost_name,
                    --     count = 1
                    -- })
                -- end

                end

                prev_pos = wp.position
            end

            ent.revive ()

            -- if game.players[1].get_item_count(placed.ghost_name) == 0 then
            --     return
            -- end

            -- It is possible that the last pole will not be connected to the just placed pole.
            -- Here we account for that and place it in the available area between those 2 poles.
            -- if euclidean(placed.position.x, placed.position.y, current_pole.position.x, current_pole.position.y) > TILE_REACH[placed.ghost_name] then
            --     prev_pos = surface.find_non_colliding_position_in_box(current_pole.name, {
            --         left_top = 
            --         { x = math.min(current_pole.position.x, placed.position.x),
            --         y = math.max(current_pole.position.y, placed.position.y) },

            --         right_bottom = 
            --         { x = math.max(current_pole.position.x, placed.position.x),
            --         y = math.min(current_pole.position.y, placed.position.y) },
            --     }, 1, true)

            --     if prev_pos ~= nil then
            --         surface.create_entity{
            --             name=placed.ghost_name,
            --             position=prev_pos, player=game.players[1],
            --             force=game.players[1].force
            --         }
            --     end
            -- end

            -- if game.players[1].get_item_count(placed.ghost_name) == 0 then return end

            -- game.players[1].remove_item({
            --     name=placed.ghost_name,
            --     count = 1
            -- })

            -- placed.revive()
        end
    end
end