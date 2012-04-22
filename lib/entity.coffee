{ EventEmitter } = require 'events'
Transform = require './transform.coffee'
Vector2 = require './vector2.coffee'

class Entity extends EventEmitter
	@drawDebug: false

	constructor: (@name = 'NOT NAMED', x = 0, y = 0) ->
		console.log('Entity::constructor', @name, x, y)
		@components = []
		@entities = []
		@entitiesToRemove = []
		@parentEntity = null
		# store user data here
		@data = {}

		@loaded = false

		@id = new Date().getTime() + "abcdefghijklmnopqrstuvwxyz"[Math.floor(Math.random() * 27)]

		@componentsToRemove = []
		new Transform(@, new Vector2(x, y))

	addComponent: (component) ->
		component.setEntity(this)
		@components.push(component)

	removeComponent: (component) ->
		for i in [0...@components.length]
			if @components[i] is component
				if @componentsToRemove.indexOf(component) is -1
					@componentsToRemove.push(component)
				break

	getComponent: (componentType) ->
		for i in [0...@components.length]
			if @components[i] instanceof componentType
				return @components[i]

	addChildEntity: (entity) ->
		@game?.entitiesById[entity.id] = entity
		entity.game = @game
		entity.setParentEntity(this)
		@entities.push(entity)

	removeChildEntity: (entity) ->
		i = 0
		for i in [0...@entities.length]
			if @entities[i] is entity
				if @entitiesToRemove.indexOf(entity) is -1
					@entitiesToRemove.push(entity)
				break

	setParentEntity: (entity) ->
		@parentEntity = entity

	update: (dt) ->
		for component in @components
			if @componentsToRemove.indexOf(component) is -1
				component.update(dt)

		for entity in @entities
			if @entitiesToRemove.indexOf(entity) is -1
				entity.update(dt)

		if @entitiesToRemove.length > 0
			for entity in @entitiesToRemove
				for index in [0...@entities.length]
					if @entities[index] is entity
						removed = @entities.splice(index, 1)
						removed[0].game = null
						removed[0].destroy()
			@entitiesToRemove = []
		#for entity in @entities
			#entity.update(dt)

		if @componentsToRemove.length > 0
			for component in @componentsToRemove
				for index in [0...@components.length]
					if @components[index] is component
						removed = @components.splice(index, 1)
						if removed[0].destroy
							removed[0].destroy()
			@componentsToRemove = []

	toString: ->
		str = @name + '\nComponents:\n'
		for component in @components
			component.toString() + '\n'

		for entity in @entities
			entity.toString() + '\n'
		return str


	draw: (dt) ->
		for component in @components
			component.draw(dt)

		for entity in @entities
			entity.draw(dt)

	load: (callback) ->
		if @components.length is 0 and @entities.length is 0
			callback()
			return

		loaded = 0
		componentLoaded = (component) =>
			loaded++
			component.loaded = true
			if loaded == @components.length
				@_loadEntities ->
					callback()

		for component in @components
			if component.load and not component.loaded
				component.load ->
					componentLoaded(component)
			else
				componentLoaded(component)

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

	drawDebug: Entity.drawDebug

	destroy: ->
		for component in @components
			if component.destroy
				component.destroy()
		for entity in @entities
			entity.destroy()

exports = module.exports = Entity

