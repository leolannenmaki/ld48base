Component = require './component'
Entity = require './entity'
Collider = require './collider'
Sprite = require './sprite'

class TileMap extends Component
	constructor: (@entity, @data, @tileData, @tileWidth, @screens) ->
		super
		@width = @data.length
		@height = @data[0].length
		@worldHeight = @width * @tileWidth
		@worldWidth = @height * @tileWidth
		@tileMap = []
		for y  in [0...@data.length]
			for x in [0...@data[y].length]
				tileId = @data[y][x]
				tile = @tileData[tileId]
				if not @tileMap[x]
					@tileMap[x] = []
				if tile.image
					entity = new Entity(@entity.name + 'x: ' + x + ' y: ' + y, @tileToWorldX(x), @tileToWorldY(y))
					entity.drawDebug = @entity.drawDebug
					if not entity.drawDebug
						sprite = new Sprite(entity, @screens, tile.image, 1, 1, undefined)
					isStatic = true
					collider = new Collider(entity, @screens, @tileWidth, @tileWidth, isStatic, !tile.collide)
					@entity.addChildEntity(entity)
					@tileMap[x][y] = { name: tile.name, image: tile.image, entity: entity, sprite: sprite, collider: collider, collide: tile.collide }

	getTileSafe: (x, y) ->
		if x >= 0 && x < @width && y >= 0 && y < @height
			@tileMap[x][y]
		else
			@tileData[0]

	tileToWorldX: (x) ->
		x * @tileWidth + @tileWidth / 2 - @width / 2

	worldToTileX: (x) ->
		Math.floor((x - @tileWidth / 2 + @width / 2) / @tileWidth)

	tileToWorldY: (y) ->
		-y * @tileWidth - @tileWidth / 2 + @height / 2

	worldToTileY: (y) ->
		Math.floor((y + @tileWidth / 2 + @height / 2) / @tileWidth)

	# Get tile inside AABB
	getTilesWithinAabb: (min, max) ->
		# round down
		minX = @worldToTileX(min.x);
		minY = @worldToTileY(min.y);

		# round up
		maxX = @worldToTileX(max.x + 0.5)
		maxY = @worldToTileY(max.y + 0.5)

		tiles = []
		for x in [minX..maxX]
			for y in [minY..maxY]
				tiles.push(@tileMap[i][j])
		tiles

exports = module.exports = TileMap

