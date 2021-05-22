class_name Actor
extends KinematicBody2D

# Both the Player and Enemy inherit this scene as they have shared behaviours
# such as speed and are affected by gravity.

var max_health = 100
var current_health = max_health
signal health_changed

export var speed = Vector2(150.0, 350.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	_velocity.y += gravity * delta

func register_hit(damage):
	current_health -= damage
	emit_signal("health_changed")
	
	if current_health <= 0:
		destroy()

# override in child class
func destroy():
	pass
