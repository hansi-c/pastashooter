class_name Player
extends Actor

var max_health = 100

# warning-ignore:unused_signal
signal collect_coin()

const FLOOR_DETECT_DISTANCE = 20.0

export(String) var action_suffix = ""

#onready var platform_detector = $PlatformDetector
onready var sprite = $Sprite
onready var gun = sprite.get_node(@"Gun")

# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	var move_direction = get_move_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, move_direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO
	if move_direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = true#platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	var look_direction = get_look_direction()

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if look_direction.x != 0:
		if look_direction.x > 0:
			sprite.scale.x = 1
			$Camera2D.offset_h = 0.5
		else:
			sprite.scale.x = -1
			$Camera2D.offset_h = -0.5

	# We use the sprite's scale to store Robi’s look direction which allows us to shoot
	# bullets forward.
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.
	var is_shooting = false
	if Input.is_action_just_pressed("shoot" + action_suffix):
		is_shooting = gun.shoot(look_direction.normalized())

	if Input.is_action_just_released("next_bullet"):
		gun.next_ammunition()

#
#	var animation = get_new_animation(is_shooting)
#	if animation != animation_player.current_animation and shoot_timer.is_stopped():
#		if is_shooting:
#			shoot_timer.start()
#		animation_player.play(animation)


func get_move_direction():
	return Vector2(
		Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump" + action_suffix) else 0
	)

func get_look_direction():
	var mouse_position = get_global_mouse_position()
	return mouse_position - global_position

# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity

#func get_new_animation(is_shooting = false):
#	var animation_new = ""
#	if is_on_floor():
#		if abs(_velocity.x) > 0.1:
#			animation_new = "run"
#		else:
#			animation_new = "idle"
#	else:
#		if _velocity.y > 0:
#			animation_new = "falling"
#		else:
#			animation_new = "jumping"
#	if is_shooting:
#		animation_new += "_weapon"
#	return animation_new
