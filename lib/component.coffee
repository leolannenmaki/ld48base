class Component
	constructor: (@entity) ->
		@loaded = false
		@entity.addComponent(this)

	update: (dt) ->

	draw: (dt) ->

	setEntity: (entity) ->
		@entity = entity

	getEntity: ->
		return @entity

exports = module.exports = Component

