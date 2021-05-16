extends RigidBody2D

func _on_Timer_timeout():
	$AnimationPlayer.play("destroy")
