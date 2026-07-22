extends CharacterBody2D

const SPEED: int = 100
const KNOCKBACK: int = 100
var Target: Node2D = null
var TargetInRange: bool = false
var Health: int = 100
var Strength: int = 10
var isAlive: bool = true

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var AttackTimer: Timer = $AttackTimer

func _physics_process(delta: float):
	if Target and isAlive:
		Attack(delta)

func Attack(delta: float):
	var Direction := (Target.position - position).normalized()
	position += Direction * SPEED * delta 
	Sprite.play("Attack")

func takeDamage(amount: int, attackerPosition: Vector2):
	Health -= amount
	
	if Health <= 0:
		Die()
	else:
		var knockbackDirection = (position - attackerPosition).normalized()
		var targetPosition = position + knockbackDirection * KNOCKBACK
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", targetPosition, 0.5)

func Die():
	isAlive = false
	Sprite.play("Death")
	$CollisionShape.set_deferred("disabled", true)
	$Sight/Area.set_deferred("disabled", true)
	
	await get_tree().create_timer(5).timeout
	queue_free()

func _on_sight_body_entered(_body: Node2D):
	if _body.name == "Player":
		Target = _body

func _on_sight_body_exited(_body: Node2D) -> void:
	if _body.name == "Player" and isAlive:
		Target = null
		Sprite.play("Idle")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		TargetInRange = true
		body.takeDamage(Strength)
		AttackTimer.start()

func _on_hitbox_body_exited(body: Node2D):
	if body.name == "Player":
		TargetInRange = false

func _on_attack_timer_timeout() -> void:
	if Target and TargetInRange:
		Target.takeDamage(Strength)
