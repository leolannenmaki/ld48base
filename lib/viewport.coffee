Component = require './component'

class ViewPort extends Component
	constructor: (@entity, @width, @height, @maxX, @maxY, @bufX = @width / 2, @bufY = @height / 2) ->
		super
		@x = 0
		@y = 0

	#No buffering means always center
	centerTo: (x, y) ->
        if ((x - @x) > (@width - @bufX))
            @x = @x + (x - @x) - (@width - @bufX)

        if ((x - @x) < (@bufX))
            @x = @x + (x - @x) - @bufX


        if ((y - @y) > (@height - @bufY))
            @y = @y + (y - @y) - (@height - @bufY)

        if ((y - @y) < (@bufY))
            @y = @y + (y - @y) - @bufY

		# Math.clamp
        @x = Math.min(Math.max(Math.floor(@x), 0), @maxX)
        @y = Math.min(Math.max(Math.floor(@y), 0), @maxY)

exports = module.exports = ViewPort

