Component = require './component'
Transform = require './transform'

class SimpleImage extends Component
	constructor: (@entity, @screens, @src, @globalCompositeOperation = 'source-over') ->
		super

	load: (callback) ->
		@img = new Image()
		@img.onload = =>
			@width = @img.width
			@height = @img.height
			if callback
				callback()
		@img.src = @src

	draw: (dt) ->
		for screen in @screens
			screen.save()
			screen.translateToOrigin(@entity, 0, 0)
			screen.rotate(@entity.getComponent(Transform).rotation.angle)
			screen.getContext().globalCompositeOperation = @globalCompositeOperation
			screen.drawImage(@img, 0, 0, @width, @height, -@width/2, -@height/2, @width, @height)
			screen.restore()


exports = module.exports = SimpleImage

