Component = require './component'
Transform = require './transform'

#http://impactjs.com/font-tool/
#http://www.zone38.net/font/ PressStart2p
font = "data:image/png;base64,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"
class Text extends Component
	constructor: (@entity, @screens, fontAsImageUrlOrSrc = font, @fontWidth = 16, @fontHeight = 16, @charCodeOffset = 32) ->
		@text = ''
		@image = new Image
		@image.src = fontAsImageUrlOrSrc

		super

	draw: (dt) ->
		if not @text
			return
		for screen in @screens
			screen.save()
			screen.translateToOrigin(@entity, 0, 0)
			#screen.rotate(@entity.getComponent(Transform).rotation.angle)

			letterSpacing = 1
			spacing = 0
			for i in [0..@text.length]
				charCode = @text.charCodeAt(i) - @charCodeOffset
				positionOnImage = charCode * @fontWidth + charCode * letterSpacing
				screen.drawImage(
					@image,
					positionOnImage, 0,
					@fontWidth, @fontHeight,
					i * @fontWidth + i * spacing, 0,
					@fontWidth, @fontHeight
				)
			screen.restore()

exports = module.exports = Text
