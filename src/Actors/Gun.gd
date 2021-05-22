class_name Gun
extends Position2D

#const BULLET_VELOCITY = 900
onready var timer = $Cooldown
var selected_bullet = 0
var available_bullets = {}
onready var Bullet = preload("res://src/Objects/Bullet.tscn")

func _ready():
	available_bullets["spirali"] = {
		"velocity": 1000,
		"cooldown": 0.3,
		"texture": load("res://assets/art/pasta/spirali.png"),
		"rotation" : -51.0
	}

	available_bullets["farfalle"] = {
		"velocity": 400,
		"cooldown": 1,
		"texture": load("res://assets/art/pasta/farfalle.png"),
		"rotation" : 0.0
	}

	timer.wait_time = available_bullets.values()[0]["cooldown"]

func _process(delta):
	var gun_rotation = $Sprite.rotation
	gun_rotation = look_at(get_global_mouse_position())
	update()

func _draw():
	var mouse_position = get_local_mouse_position()
	draw_line(position, mouse_position, Color.white)

func next_ammunition():
	selected_bullet = (selected_bullet + 1) % available_bullets.values().size()
	timer.wait_time = available_bullets.values()[selected_bullet]["cooldown"]

func shoot(direction):
	if timer.is_stopped():
		timer.start()
	else:
		return false

	var bullet = Bullet.instance()
	configure_bullet(bullet)

	bullet.global_position = global_position
	bullet.linear_velocity = direction * bullet.velocity

	bullet.set_as_toplevel(true)
	add_child(bullet)
	#sound_shoot.play()
	return true

func configure_bullet(bullet):
	var bullet_spec = available_bullets.values()[selected_bullet]
	var sprite = bullet.get_node("Sprite")
	sprite.set_texture(bullet_spec["texture"])
	sprite.rotation_degrees = bullet_spec["rotation"]
	bullet.velocity = bullet_spec["velocity"]
	bullet.set_collision_mask_bit(0, false)
