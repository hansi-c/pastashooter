class_name Gun
extends Position2D

const BULLET_VELOCITY = 500

const Bullet = preload("res://src/Objects/Bullet.tscn")
onready var timer = $Cooldown

func _process(delta):
	update()

func _draw():
	var mouse_position = get_local_mouse_position()
	draw_line(position, mouse_position, Color.white)

func shoot(direction):
	if not timer.is_stopped():
		return false
	var bullet = Bullet.instance()
	bullet.global_position = global_position
	bullet.linear_velocity = direction * BULLET_VELOCITY
	#bullet.transform.rotation = global_position * get_global_mouse_position()

	bullet.set_as_toplevel(true)
	add_child(bullet)
	#sound_shoot.play()
	return true
