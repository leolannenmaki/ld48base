Component = require './component'

class Input extends Component
	constructor: (@entity, @handlers, @mouseTargetElem = null) ->
		super
		keys =
			8: 'backspace'
			9: 'tab'
			13: 'enter'
			16: 'shift'
			17: 'ctrl'
			18: 'alt'
			20: 'caps lock'
			27: 'escape'
			33: 'page up'
			34: 'page down'
			35: 'end'
			36: 'home'
			45: 'insert'
			46: 'delete'
			32: 'space'
			37: 'left'
			38: 'up'
			39: 'right'
			40: 'down'
			48: '0'
			49: '1'
			50: '2'
			51: '3'
			52: '4'
			53: '5'
			54: '6'
			55: '7'
			56: '8'
			57: '9'
			65: 'a'
			66: 'b'
			67: 'c'
			68: 'd'
			69: 'e'
			70: 'f'
			71: 'g'
			72: 'h'
			73: 'i'
			74: 'j'
			75: 'k'
			76: 'l'
			77: 'm'
			78: 'n'
			79: 'o'
			80: 'p'
			81: 'q'
			82: 'r'
			83: 's'
			84: 't'
			85: 'u'
			86: 'v'
			87: 'w'
			88: 'x'
			89: 'y'
			90: 'z'

		buttons =
			0: 'leftButton'
			2: 'rightButton'

		@pressedKeys = {}
		@releasedKeys = {}
		@pressedButtons = {}
		@releasedButtons = {}
		@disabled = false

		preventDefault = false
		stopPropagation = false
		useCapture = false

		document.addEventListener('keydown', ((event) => @keyDown(keys[event.keyCode]); event.preventDefault() if preventDefault; event.stopPropagation() if stopPropagation), useCapture)
		document.addEventListener('keyup', ((event) => @keyUp(keys[event.keyCode]); event.preventDefault() if preventDefault; event.stopPropagation() if stopPropagation), useCapture)
		@entity.input = @


		if mouseTargetElem
			findXAndY = (ev) =>
				x = 0
				y = 0
				if ev.offsetX or ev.offsetX is 0
					x = ev.offsetX
					y = ev.offsetY
				else if ev.layerX or ev.layerX is 0
					x = ev.layerX
					y = ev.layerY

				x = x - mouseTargetElem.width / 2
				y = -(y - mouseTargetElem.height / 2)
				console.log(x, y)
				if ev.type == 'mousedown'
					@mouseDown(buttons[event.button], x, y)
				else if ev.type == 'mouseup'
					@mouseUp(buttons[event.button], x, y)
				ev.preventDefault() if preventDefault
				ev.stopPropagation() if stopPropagation

			mouseTargetElem.addEventListener('mousedown', findXAndY, useCapture);
			#canvas.addEventListener('mousemove', ev_canvas, useCapture);
			mouseTargetElem.addEventListener('mouseup',   findXAndY, useCapture);

	keyDown: (key) ->
		if not @pressedKeys[key]
			@pressedKeys[key] = true

	keyUp: (key) ->
		if @pressedKeys[key]
			delete @pressedKeys[key]
			@releasedKeys[key] = true

	isKeyDown: (key) ->
		@pressedKeys[key] == true

	mouseDown: (button, x, y) ->
		if not @pressedButtons[button]
			@pressedButtons[button] = { x: x, y: y }

	mouseUp: (button, x, y) ->
		if @pressedButtons[button]
			delete @pressedButtons[button]
			@releasedButtons[button] = { x: x, y: y }

	update: ->
		if @disabled
			return
		for key of @pressedKeys
			if @handlers[key]
				@handlers[key]()
		for key of @releasedKeys
			if @handlers[key]
				@handlers[key](true)
		@releasedKeys = {}
		for button of @pressedButtons
			if @handlers[button]
				@handlers[button](false, @pressedButtons[button].x, @pressedButtons[button].y)
		for button of @releasedButtons
			if @handlers[button]
				@handlers[button](true, @releasedButtons[button].x, @releasedButtons[button].y)
		@releasedButtons = {}

exports = module.exports = Input

