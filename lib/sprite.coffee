Component = require './component'

class Sprite extends Component
	constructor: (@entity, @screens, @src, @rows, @columns, @frameTime, @xOffset = 0, @yOffset = 0, @pauseOnStop = true) ->
		super
		@img = new Image()
		@frameCount = @rows * @columns
		@currentFrame = 0
		@currentFrameDelta = 0
		@flip = false

	load: (callback) ->
		@img.onload = =>
			@width = @img.width / @columns
			@height = @img.height / @rows
			if callback
				callback()
		@img.src = @src

	draw: (dt) ->
		xPos = @currentFrame % @columns
		yPos = Math.floor(@currentFrame  % @rows)
		for screen in @screens
			screen.save()
			screen.translateToOrigin(@entity, 0, 0)
			#screen.rotate(@entity.getComponent(Transform).rotation.angle)
			if @flip
				screen.flip()
			screen.drawImage(@img, xPos * @width, yPos * @height, @width, @height, -@width/2 + @xOffset, -@height/2 + @yOffset, @width, @height)
			screen.restore()

	update: (dt) ->
		@currentFrameDelta += dt
		if (@currentFrameDelta > @frameTime)
			@currentFrameDelta = 0
			if @currentFrame < (@frameCount - 1)
				@currentFrame++
			else
				@currentFrame = 0

exports = module.exports = Sprite

