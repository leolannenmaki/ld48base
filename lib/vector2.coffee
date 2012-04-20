# implement pooling
class Vector2
	@create: (obj) ->
		new Vector2(obj.x, obj.y)

	constructor: (@x = 0, @y = 0) ->

	add: (v) ->
		@x += v.x
		@y += v.y
		@

	subtract: (v) ->
		@x -= v.x
		@y -= v.y
		@

	dot: (v) ->
		@x * v.x + @y * v.y

	multiply: (v) ->
		@x *= v.x
		@y *= v.y
		@

	multiplyScalar: (s) ->
		@x *= s
		@y *= s
		@

	negate: ->
		@multiplyScalar(-1)
		@

	length: ->
		Math.sqrt(@x * @x + @y * @y)

	distance: (v) ->
		dx = @x - v.x
		dy = @y - v.y
		Math.sqrt(dx * dx + dy * dy)

	divide: (v) ->
		if v.x
			@x /= v.x
		else
			@x = 0
		if v.y
			@y /= v.y
		else
			@y = 0
		@

	divideScalar: (s) ->
		if s
			@x /= s
			@y /= s
		else
			@x = 0
			@y = 0
		@

	abs: ->
		@x = Math.abs(@x)
		@y = Math.abs(@y)
		@

	clone: ->
		new Vector2(@x, @y)

	perpendicular: ->
		[@x, @y] = [@y, -@x]
		@

	majorAxis: ->
		if Math.abs(@x) > Math.abs(@y)
			new Vector2((if @x > 0 then 1 else -1), 0)
		else
			new Vector2(0, (if @y > 0 then 1 else -1))

	min: (other) ->
		new Vector2(Math.min(@x, other.x), Math.min(@y, other.y))

	max: (other) ->
		new Vector2(Math.max(@x, other.x), Math.max(@y, other.y))

	normalize: ->
		@divideScalar(@length())

	toLength: (l) ->
		@normalize().multiplyScalar(l)

	toString: ->
		"x: #{@x}, y: #{@y}"

	equal: (other) ->
		@x is other.x and @y is other.y

exports = module.exports = Vector2

