getbounds = (elm) ->
	elm = $ elm if not elm.jquery?

	top: elm.offset().top
	left: elm.offset().left
	right: elm.offset().left + elm.outerWidth true
	bottom: elm.offset().top + elm.outerHeight true

anchor = (bounds, direction) ->
	x: switch direction
		when 'left','right' then bounds[direction]
		when 'up','down' then bounds.left + (bounds.right - bounds.left) / 2
	y: switch direction
		when 'left','right' then bounds.top + (bounds.bottom - bounds.top) / 2
		when 'up' then bounds.top
		when 'down' then bounds.bottom

distance = (a, b) ->
	w = Math.abs a.x - b.x
	h = Math.abs a.y - b.y

	Math.sqrt Math.pow(w, 2) + Math.pow(h, 2)

$ ->
	root = $ 'body'
	selector = 'a'

	root.on 'keydown', (event) ->
		direction = switch event.keyCode
			when 37 then 'left'
			when 38 then 'up'
			when 39 then 'right'
			when 40 then 'down'

		return if direction not in ['up', 'down', 'left', 'right']

		current = $ ':focus'
		return if not current?

		opposite = switch direction
			when 'left' then 'right'
			when 'right' then 'left'
			when 'up' then 'down'
			when 'down' then 'up'

		bounds = getbounds current

		candidates =  $(selector).filter ->
			switch direction
				when 'left' then getbounds(this).right <= bounds.left
				when 'right' then getbounds(this).left >= bounds.right
				when 'up' then getbounds(this).bottom <= bounds.top
				when 'down' then getbounds(this).top >= bounds.bottom

		point = anchor bounds, direction
		candidates.sort (a,b) -> 
			ba = getbounds a
			bb = getbounds b

			pa = anchor ba, opposite
			pb = anchor bb, opposite

			da = distance point, pa
			db = distance point, pb
			
			switch 
				when da > db then 1
				when da < db then -1
				else 0			

		.first().focus()
		false

	root.on 'focus', -> 
		root.find(selector).first().focus()
		false

	root.focus()

