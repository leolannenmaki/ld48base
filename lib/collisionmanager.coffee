Component = require './component'
Collider = require './collider'

class CollisionManager extends Component
	constructor: (@game) ->
		super

	update: (dt) ->
		collisions = {}
		for i in [0...Collider.colliders.length]
			a = Collider.colliders[i]
			if a.noCollision
				continue

			for j in [(i + 1)...Collider.colliders.length]
				b = Collider.colliders[j]

				if a.static and b.static
					continue

				# TODO add velocity
				if not a.overlap(b, dt)
					continue

				dataForA = a.distance(b)
				dataForB = { planeNormal: dataForA.planeNormal.clone().negate(), distance: dataForA.distance, me: b, other: a }

				collisions[a.entity.id] = (collisions[a.entity.id] || [])

				#foundInternal = false
				#for collision in collisions[a.entity.id]
					#if a.overlap(collision[1].other, dt)
						#foundInternal = true
						#break
				#if foundInternal
					#continue


				collisions[a.entity.id].push(
					[b.entity, dataForA]
				)
				collisions[b.entity.id] = (collisions[b.entity.id] || [])
				collisions[b.entity.id].push(
					[a.entity, dataForB]
				)

		for id, cols of collisions
			@game.entitiesById[id].emit('collision', dt, cols)

exports = module.exports = CollisionManager

