--- Position module
-- @module Position

Position = {}

require 'stdlib/core'

--- Converts a position in the array format to a position in the table format
-- @param pos_arr the position to convert
-- @return a converted position, { x = pos_arr[1], y = pos_arr[2] }
function Position.to_table(pos_arr)
    fail_if_missing(pos_arr, "missing position argument")

    if #pos_arr == 2 then
        return { x = pos_arr[1], y = pos_arr[2] }
    end
    return pos_arr
end
