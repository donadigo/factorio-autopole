--- Tile module
--- <p>A tile represents a 1x1 area on a surface in factorio
-- @module Tile

require 'stdlib/core'
require 'stdlib/area/position'

Tile = {}
MAX_UINT = 4294967296

--- Calculates the tile coordinates for the position given
--  @param position to calculate the tile for
--  @return the tile position
function Tile.from_position(position)
    position = Position.to_table(position)
    return {x =  math.floor(position.x), y = math.floor(position.y)}
end
