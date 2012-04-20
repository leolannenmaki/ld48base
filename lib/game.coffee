Constants = require './constants.coffee'

if process.title is 'browser'
	nextTick = window.requestAnimationFrame ?
		window.webkitRequestAnimationFrame ?
		window.mozRequestAnimationFrame ?
		window.oRequestAnimationFrame ?
		window.msRequestAnimationFrame ?
		(callback, element) -> window.setTimeout(callback, 1000 / 60)
else
	nextTick = process.nextTick

class Game
	constructor: () ->
		@gameUpdatesPerSecond = 60
		@skipMillis = 1000 / @gameUpdatesPerSecond
		@maxFrameSkip = 10
		@lastTime = null
		@running = false

		@entities = []
		@entitiesById = {}
		@managers = []

		@updateLogicCount = 0
		@updateDisplayCount = 0

		@entitiesToRemove = []

	gameLoop: ->
		last = Date.now()
		update = (now) =>
			@updateLogic(@skipMillis)
			@updateManagers(@skipMillis)
			@updateDisplay(@skipMillis)
			if (@running)
				nextTick(update)
		nextTick(update)

	start: ->
		if (!@running)
			@_loadEntities =>
				@running = true
				@gameLoop()

	_loadEntities: (callback)->
		if @entities.length == 0
			callback()
			return

		loaded = 0
		entityLoaded = (entity) =>
			loaded++
			entity.loaded = true
			if loaded == @entities.length
				callback()

		for entity in @entities
			if entity.load and not entity.loaded
				entity.load ->
					entityLoaded(entity)
			else
				entityLoaded(entity)

	pause: ->
		@running = false

	updateLogic: (dt) ->
		for entity in @entities
			if @entitiesToRemove.indexOf(entity) is -1
				entity.update(dt / 1000)

		if @entitiesToRemove.length > 0
			for entity in @entitiesToRemove
				for index in [0...@entities.length]
					if @entities[index] is entity
						removed = @entities.splice(index, 1)
						delete @entitiesById[removed.id]
						removed[0].game = null
						removed[0].destroy()
			@entitiesToRemove = []
		@updateLogicCount++

	updateManagers: (dt) ->
		for manager in @managers
			manager.update(dt / 1000)

	updateDisplay: (dt) ->
		#@scene.setPosition(this.viewPort.x, this.viewPort.y)
		for entity in @entities
			entity.draw(dt / 1000)
		@updateDisplayCount++

	addEntity: (entity) ->
		entity.game = @
		# TODO make recursive
		for child in entity.entities
			@entitiesById[child.id] = child
		@entities.push(entity)
		@entitiesById[entity.id] = entity

	removeEntity: (entity) ->
		i = 0
		for i in [0...@entities.length]
			if @entities[i] is entity
				if @entitiesToRemove.indexOf(entity) is -1
					@entitiesToRemove.push(entity)
				break

	# For managers
	addComponent: (manager) ->
		@managers.push(manager)

exports = module.exports = Game

