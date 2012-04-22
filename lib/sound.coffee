Component = require './component'

class Sound extends Component
	constructor: (@entity, @src, @volume = 1, @autoPlay = false, @loop = false, @destroyOnStop = false) ->
		super
		@audio = document.createElement('audio') #new Audio()
		@audio.volume = @volume
		@audio.loop = @loop

		@audio.addEventListener('ended', =>
			@audio.currentTime = 0
			if @onStop
				debugger
				@onStop()
			if not @loop
				@playing = false
				if @destroyOnStop
					try
						document.removeChild(@audio)
					catch error
					@entity.removeComponent(@)
		)
		@playing = false
		@loaded = false

	load: (callback) ->
		id = 0
		audioReady = =>
			if @audio.readyState
				@loaded = true
				clearTimeout(id)
				callback()
			else
				setTimeout(audioReady, 250);
		id = setTimeout(audioReady, 1)
		@audio.src = @src

	update: (dt) ->
		if @loaded and not @playing and @autoPlay
        	@audio.play()

	pause: ->
		@audio.pause()
		@playing = false

	play: ->
		console.log(@playing)
		if @playing
			@audio.currentTime = 0
		else
			@audio.play()
			@playing = true

exports = module.exports = Sound

