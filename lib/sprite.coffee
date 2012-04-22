Component = require './component'

class Sprite extends Component
	constructor: (@entity, @screens, @src, @rows, @columns, @frameTime, @xOffset = 0, @yOffset = 0, @pauseOnStop = true, @cellWidth = 0, @cellHeight = 0) ->
		super
		@img = new Image()
		@frameCount = @rows * @columns
		@currentFrame = 0
		@currentFrameDelta = 0
		@flip = false
		@flipY = false
		@hide = false

	load: (callback) ->
		@img.onload = =>
			if @cellWidth > 0
				@width = @cellWidth
			else
				@width = @img.width / @columns
			if @cellHeight > 0
				@height = @cellHeight
			else
				@height = @img.height / @rows
			if callback
				callback()
		@img.src = @src

	draw: (dt) ->
		if @hide
			return
		xPos = @currentFrame % @columns
		yPos = Math.floor(@currentFrame  % @rows)
		for screen in @screens
			screen.save()
			# TODO why / 4, there is a bug hiding somewhere
			screen.translateToOrigin(@entity, @width / 4, @height / 2)
			#screen.rotate(@entity.getComponent(Transform).rotation.angle)
			if @flip
				screen.flip()
			if @flipY
				screen.flipY()
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

