Vector2 = require './vector2.coffee'
exports = module.exports =
	GRAVITY: 40
	MAX_SPEED: 1000
	SCREEN_DIMENSIONS: new Vector2(320, 240)
	WORLD_HALF_EXTENTS: new Vector2(160, 120)
	TILE_SIZE: 32
	GROUND_FRICTION: 0.6
	AIR_FRICTION: 0.3

