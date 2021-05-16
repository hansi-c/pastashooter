extends Position2D

func _process(delta):
	update()

func _draw():
	var mouse_position = get_local_mouse_position()
	draw_line(position, mouse_position, Color.white)
