utils = {}
utils.__index = utils

function utils.euclidean(x, y, x2, y2)
    return math.sqrt((x2 - x) ^ 2 + (y2 - y) ^ 2)
end

function utils.is_pole_connected(pole)
    local count = 0
    for _ in pairs(pole.neighbours["copper"]) do count = count + 1 end
    return count > 0
end

function utils.find_closest_pole(player, target)
    local filtered = target.surface.find_entities_filtered{
        name = { "small-electric-pole", "medium-electric-pole", "big-electric-pole" }
    }

    if filtered == nil then return end

    local closest = filtered[1]
    local closest_dist = utils.euclidean(filtered[1].position.x, filtered[1].position.y, target.position.x, target.position.y)
    for i, ent in pairs(filtered) do
        if i ~= 1 then
            if ent ~= target then
                local d = utils.euclidean(ent.position.x, ent.position.y, target.position.x, target.position.y)
                if d < closest_dist then
                    closest = ent
                    closest_dist = d
                end
            end
        end
    end

    return closest
end