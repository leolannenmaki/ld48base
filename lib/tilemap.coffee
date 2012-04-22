Component = require './component'
Entity = require './entity'
Collider = require './collider'
Sprite = require './sprite'

class TileMap extends Component
	constructor: (@entity, @level, @tileData, @tileWidth, @screens) ->
		super
		@loadTileData(@level)

	loadTileData: (@level) ->
		@width = @level.length
		@height = @level[0].length
		@worldHeight = @width * @tileWidth
		@worldWidth = @height * @tileWidth
		@tileChildren = []
		@tileMap = []
		for y  in [0...@level.length]
			for x in [0...@level[y].length]
				tileId = @level[y][x]
				tile = @tileData[tileId]
				if not @tileMap[x]
					@tileMap[x] = []
				if tile.image and not tile.noTile
					entity = new Entity(@entity.name + 'x: ' + x + ' y: ' + y, @tileToWorldX(x), @tileToWorldY(y))
					entity.drawDebug = @entity.drawDebug
					if not entity.drawDebug
						rows = if tile.animated then tile.rows else 1
						columns = if tile.animated then tile.columns else 1
						frameTime = if tile.animated then tile.frameTime else 0
						sprite = new Sprite(entity, @screens, tile.image, rows, columns, frameTime)
					isStatic = true
					collider = new Collider(entity, @screens, @tileWidth, @tileWidth, isStatic, !tile.collide)
					entity.data.walkable = tile.walkable
					entity.data.tileName = tile.name
					@entity.addChildEntity(entity)
					@tileChildren.push(entity)
					@tileMap[x][y] = { name: tile.name, image: tile.image, entity: entity, sprite: sprite, collider: collider, collide: tile.collide }

	destroy: ->
		@destroyTileData()

	destroyTileData: ->
		for entity in @tileChildren
			@entity.removeChildEntity(entity)
		@tileChildren = []

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

