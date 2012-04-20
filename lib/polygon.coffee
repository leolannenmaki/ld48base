Component = require './component'
Transform = require './transform'

class Polygon extends Component
	constructor: (@entity, @screens, @points, @strokeStyle = 'green', @scale = 1) ->
		super

	draw: (dt) ->
		for screen in @screens
			screen.save()
			screen.translateToOrigin(@entity, 0, 0)
			screen.rotate(@entity.getComponent(Transform).rotation.angle)
			context = screen.getContext()
			# TODO: why is this needed? FOR BOX 2D
			context.scale(-1, 1)
			context.fillStyle = @fillStyle
			context.strokeStyle = @strokeStyle
			context.beginPath()
			context.moveTo(@points[0].x * @scale, @points[0].y * @scale)
			for i in [1...@points.length]
				context.lineTo(@points[i].x * @scale, @points[i].y * @scale)
			# It seems that the last lineTo is not needed
			#context.lineTo(@points[0].x * @scale, @points[0].y * @scale)
			context.closePath()
			context.stroke()
			screen.restore()
	destroy: ->
		if Component.prototype.destroy
			super
		console.log('Polygon#destroy')

exports = module.exports = Polygon

