extends RigidBody2D
class_name Bullet

export var velocity = 900.0
export var damage = 25.0

func _physics_process(delta):
	var movecurve = get_linear_velocity().normalized()
	self.rotation = movecurve.angle()

func _on_Timer_timeout():
	$AnimationPlayer.play("destroy")

func _on_body_entered(body):
	print("body entered: %s" % body)
	if body is Actor:
		print("body is actor. current health: %s" % body.current_health)
		body.register_hit(damage)
