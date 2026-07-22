extends CharacterBody2D

const SPEED = 300.0
var lastDirection = Vector2.RIGHT
var isAttacking: bool = false

@onready var Sprite: AnimatedSprite2D = $Sprite

func _physics_process(_delta: float):
	if Input.is_action_just_pressed("Attack"):
		Attack()
	processMovement()
	processAnimation()
	move_and_slide()

func processMovement():
	var Direction := Input.get_vector("Left", "Right", "Up", "Down")
	
	if Direction:
		velocity = Direction * SPEED
		lastDirection = Direction
	else:
		velocity = Vector2.ZERO

func processAnimation():
	if isAttacking:
		return
	if velocity != Vector2.ZERO:
		playAnimation("Walk", lastDirection)
	else:
		playAnimation("Idle", lastDirection)

func playAnimation(prefix: String, direction: Vector2):
	if direction.x != 0:
		Sprite.flip_h = direction.x < 0
		Sprite.play(prefix + "Right")
	elif direction.y > 0:
		Sprite.play(prefix + "Down")
	elif direction.y < 0:
		Sprite.play(prefix + "Up")

func Attack():
	isAttacking = true
	playAnimation("Attack", lastDirection)

func _on_sprite_animation_finished():
	if isAttacking:
		isAttacking = false
