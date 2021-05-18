extends RigidBody2D
class_name Bullet

export var velocity = 900

func _physics_process(delta):
	var movecurve = get_linear_velocity().normalized()
	self.rotation = movecurve.angle()

func _on_Timer_timeout():
	$AnimationPlayer.play("destroy")

func _on_body_entered(body):
	if body is Enemy:
		body.destroy()
