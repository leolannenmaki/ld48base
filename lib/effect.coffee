Component = require './component'
Transform = require './transform'

class Effect extends Component
	constructor: (@entity, @screens, @doEffect) ->
		super

	draw: (dt) ->
		for screen in @screens
			screen.save()
			screen.translateToOrigin(@entity, 0, 0)
			screen.rotate(@entity.getComponent(Transform).rotation.angle)

			@doEffect(screen.getContext())
			screen.restore()

exports = module.exports = Effect

