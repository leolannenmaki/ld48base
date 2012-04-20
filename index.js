// require('coffee-script') Cannot require here as browserify barks
var exports = module.exports = {
	Vector2: require('./lib/vector2.coffee'),
	Constants: require('./lib/constants.coffee'),
	Game: require('./lib/game.coffee'),
	Entity: require('./lib/entity.coffee'),
	Component: require('./lib/component.coffee'),
	Transform: require('./lib/transform.coffee'),
	Screen: require('./lib/screen.coffee'),
	Collider: require('./lib/collider.coffee'),
	CollisionManager: require('./lib/collisionmanager.coffee'),
	Effect: require('./lib/effect.coffee'),
	Input: require('./lib/input.coffee'),
	Polygon: require('./lib/polygon.coffee'),
	SimpleImage: require('./lib/simpleimage.coffee'),
	Sound: require('./lib/sound.coffee'),
	Sprite: require('./lib/sprite.coffee'),
	Text: require('./lib/text.coffee'),
	TileMap: require('./lib/tilemap.coffee'),
	ViewPort: require('./lib/viewport.coffee')
};

