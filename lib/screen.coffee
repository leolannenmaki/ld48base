Component = require './component.coffee'
Constants = require './constants.coffee'
Transform = require './transform.coffee'

class Screen extends Component
	constructor: (@entity, @width = Constants.SCREEN_DIMENSIONS.x, @height = Constants.SCREEN_DIMENSIONS.y, @context = null) ->
		super
		if not @context
			@canvas = document.createElement('canvas')
			#@canvas.style.zoom = 2
			@canvas.width = @width
			@canvas.height = @height
			#for scaling see
			#https://github.com/mrdoob/three.js/issues/516
			@context = @canvas.getContext('2d')
		@context.mozImageSmoothingEnabled = false
		@context.strokeStyle = 'black'

	destroy: ->
		if @canvas and @canvas.parentNode
			@canvas.parentNode.removeChild(@canvas)

	load: (callback) ->
		if @canvas
			if document
				document.body.appendChild(@canvas)
			callback()

	draw: (dt) ->
		if @bgColor
			@context.fillStyle = @bgColor
			@context.fillRect(0, 0, @width, @height)
		else
			@context.clearRect(0, 0, @width, @height)

	flip: ->
		@context.scale(-1, 1)

	flipY: ->
		@context.scale(1, -1)

	drawImage: (img, imgX, imgY, imgWidth, imgheight, x, y, width, height) ->
		if x <= @width and y <= @height and (x + width) > 0 and (y + height) > 0
			@context.drawImage(img, imgX, imgY, imgWidth, imgheight, x, y, width, height)

	centerInWindow: ->
		if @canvas and @canvas.classList
			@canvas.classList.add('center')

	save: ->
		@context.save()

	restore: ->
		@context.restore()

	translateToOrigin: (entity, xOffset = 0, yOffset = 0) ->
		xTemp = entity.getComponent(Transform).position.x
		yTemp = entity.getComponent(Transform).position.y

		e = entity
		while e.parentEntity
			xTemp += e.parentEntity.getComponent(Transform).position.x
			yTemp += e.parentEntity.getComponent(Transform).position.y
			e = e.parentEntity

		x = xTemp + (@width / 2)
		y = @height / 2 - yTemp

		x -= @entity.getComponent(Transform).position.x
		y += @entity.getComponent(Transform).position.y
		@context.translate(x + xOffset, y + yOffset)

	rotate: (angle) ->
		@context.rotate(Math.PI / 2 + angle)

	getContext: ->
		return @context

	getCanvas: ->
		return @context.canvas

exports = module.exports = Screen

