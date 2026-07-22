extends CharacterBody2D

signal Died

const SPEED = 300.0
var lastDirection = Vector2.RIGHT
var isAttacking: bool = false
var HitboxOffset: Vector2
var isAlive: bool = true
var MaxHealth: int = 100
var Health: int = MaxHealth
var Strength: int = 20

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var Hitbox: Area2D = $Hitbox
@onready var DamageCooldown: Timer = $DamageCooldown

func _ready():
	HitboxOffset = Hitbox.position

func _physics_process(_delta: float):
	Hitbox.monitoring = false
	
	if isAlive:
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
		updateHitboxOffset()
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
	Hitbox.monitoring = true
	playAnimation("Attack", lastDirection)

func _on_sprite_animation_finished():
	if isAttacking:
		isAttacking = false

func updateHitboxOffset():
	var x := HitboxOffset.x
	var y := HitboxOffset.y
	
	match lastDirection:
		Vector2.LEFT:
			Hitbox.position = Vector2(-x, y)
		Vector2.RIGHT:
			Hitbox.position = Vector2(x, y)
		Vector2.DOWN:
			Hitbox.position = Vector2(-y, x)
		Vector2.UP:
			Hitbox.position = Vector2(y, -x)

func takeDamage(amount: int):
	if isAlive:
		if DamageCooldown.time_left < 0:
			return
		
		Health -= amount
		PlayerStats.Health = Health
		print(PlayerStats.Health)
		
		if Health <= 0:
			Die()
		
		DamageCooldown.start()

func Die():
	Sprite.play("Dying")
	isAlive = false
	await Sprite.animation_finished
	Died.emit()

func _on_hitbox_body_entered(_body: Node2D):
	if isAttacking and _body.name.begins_with("Slime"):
		_body.takeDamage(Strength, position)
