extends Node2D

var Level = 2

var currentLevel: Node2D = null

func _ready():
	currentLevel = get_node("Level")
	loadLevel(Level)

func loadLevel(levelNumber: int):
	if currentLevel:
		currentLevel.queue_free()
	
	var nextLevel = "res://Scenes/Levels/Level-%s.tscn" % levelNumber
	currentLevel = load(nextLevel).instantiate()
	add_child(currentLevel)
	currentLevel.name = "Level"
	setupLevel(currentLevel)

func setupLevel(level: Node2D):
	var Player = level.get_node("Player")
	Player.Died.connect(PlayerDied)
	
	var Exit = currentLevel.get_node_or_null("Exit")
	if Exit:
		Exit.body_entered.connect(_on_exit_body_entered)

func PlayerDied():
	await get_tree().create_timer(2.0).timeout
	PlayerStats.Reset()
	Level = 2
	loadLevel(Level)

func _on_exit_body_entered(body: Node2D):
	if body.name == "Player":
		Level += 1
		call_deferred("loadLevel", Level)
