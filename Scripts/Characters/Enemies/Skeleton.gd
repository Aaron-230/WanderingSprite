extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_sight_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_sight_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_attack_timer_timeout() -> void:
	pass # Replace with function body.
