Component = require './component'
Transform = require './transform'
Vector2 = require './vector2'

class Collider extends Component
	@colliders = []
	constructor: (@entity, @screens, @width, @height, @static = false, @noCollision = false) ->
		@halfWidth = @width / 2
		@halfHeight = @height / 2
		@halfExtents = new Vector2(@halfWidth, @halfHeight)
		@transform = @entity.getComponent(Transform)

		Collider.colliders.push(this)
		super

	destroy: ->
		for i in [0...Collider.colliders.length]
			if this is Collider.colliders[i]
				Collider.colliders.splice(i, 1)
				break

	contains: (other) ->
		aMinX = @transform.position.x - @halfWidth
		aMaxX = @transform.position.x + @halfWidth

		aMinY = @transform.position.y - @halfHeight
		aMaxY = @transform.position.y + @halfHeight
		if (aMinX <= other.x <= aMaxX) and (aMinY <= other.y <= aMaxY)
			true
		else
			false

	overlap: (other, dt) ->
		aMinX = @transform.position.x - @halfWidth + Math.min(@transform.velocity.x / dt, 0)
		aMaxX = @transform.position.x + @halfWidth + Math.max(@transform.velocity.x / dt, 0)

		aMinY = @transform.position.y - @halfHeight + Math.min(@transform.velocity.y / dt, 0)
		aMaxY = @transform.position.y + @halfHeight + Math.max(@transform.velocity.y / dt, 0)

		bMinX = other.transform.position.x - other.halfWidth + Math.min(other.transform.velocity.x / dt, 0)
		bMaxX = other.transform.position.x + other.halfWidth + Math.max(other.transform.velocity.x / dt, 0)

		bMinY = other.transform.position.y - other.halfHeight + Math.min(other.transform.velocity.y / dt, 0)
		bMaxY = other.transform.position.y + other.halfHeight + Math.max(other.transform.velocity.y / dt, 0)

		if aMinX > bMaxX
			false
		else if aMaxX < bMinX
			false
		else if aMaxY < bMinY
			false
		else if aMinY > bMaxY
			false
		else
			true

	distance: (other) ->
		combinedExtents = other.halfExtents.clone().add(@halfExtents)
		delta = other.transform.position.clone().subtract(@transform.position)

		# closest plane to the point
		planeNormal = delta.majorAxis().negate()
		planeCenter = planeNormal.clone().multiply(combinedExtents).add(other.transform.position)

		# point from plane
		planeDelta = @transform.position.clone().subtract(planeCenter)
		distance = planeDelta.dot(planeNormal)

		{ planeNormal: planeNormal, distance: distance, me: this, other: other }

	draw: (dt) ->
		if not @entity.drawDebug
			return
		for screen in @screens
			screen.save()

			screen.translateToOrigin(@entity, 0, 0)
			context = screen.getContext()


			context.beginPath()
			context.strokeStyle = 'red'
			context.moveTo(-@halfWidth + 0.5, -@halfHeight + 0.5)
			context.lineTo(-@halfWidth + 0.5, @halfHeight - 0.5)
			context.lineTo(@halfWidth - 0.5, @halfHeight - 0.5)
			context.lineTo(@halfWidth - 0.5, -@halfHeight + 0.5)
			context.closePath()
			context.stroke()

			context = screen.getContext()
			context.strokeStyle = 'black'
			context.fillStyle = 'red'
			context.font = '6px Verdana'
			context.fillText(Math.round(@transform.position.x) + ', ' + Math.round(@transform.position.y), -15, 0)
			screen.restore()

			screen.restore()

exports = module.exports = Collider

