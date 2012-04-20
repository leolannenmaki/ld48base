Component = require './component.coffee'
Vector2 = require './vector2.coffee'
Constants = require './constants.coffee'

class Transform extends Component
	constructor: (@entity, @position = new Vector2(0, 0), @rotation = new Vector2(0, 0), @scale = new Vector2(1, 1)) ->
		@velocity = new Vector2(0, 0)
		@direction = new Vector2(0, 1)
		@previousPosition = null
		@screens = []
		super

	update: (dt) ->
		@previousPosition = @position.clone()
		# integrate position
		@position.add(@velocity.clone().multiplyScalar(dt))
		@clampVelocity()
		@updateAxes()

	clampVelocity: ->
		@velocity.x = Math.max(Math.min(@velocity.x, Constants.MAX_SPEED), -Constants.MAX_SPEED)
		@velocity.y = Math.max(Math.min(@velocity.y, Constants.MAX_SPEED), -Constants.MAX_SPEED)

	updateAxes: ->
		@direction = @position.clone().subtract(@previousPosition)
		@direction.normalize()

		upvector =
			   x: 0
			   y: 1

		@direction.angle = Math.acos(@direction.x * upvector.y + @direction.y * upvector.x)

		if @direction.y < 0
			@direction.angle = Math.PI - @direction.angle + Math.PI

	draw: (dt) ->
		if not @entity.drawDebug
			return
		for screen in @screens
			screen.save()

			screen.translateToOrigin(@entity)
			#screen.rotate(@entity.getComponent(Transform).rotation.angle)
			#
			context = screen.getContext()
			context.strokeStyle = 'black'
			context.fillStyle = 'red'
			context.fillText('Vx: ' + Math.round(@velocity.x), 15, 0)
			context.fillText('Vy: ' + Math.round(@velocity.y), 15, 10)
			screen.restore()

exports = module.exports = Transform

