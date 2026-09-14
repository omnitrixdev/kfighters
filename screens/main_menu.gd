extends Control

func _ready() -> void:
	$StoryButton.pressed.connect(_on_story)
	$FightButton.pressed.connect(_on_fight)
	# Quest is disabled for now (daily check-in comes in Milestone M9).


func _go(mode: GameManager.Mode) -> void:
	GameManager.start_match(null, null, mode)
	SceneManager.goto_scene("res://screens/character_select.tscn")


func _on_story() -> void:
	_go(GameManager.Mode.STORY)


func _on_fight() -> void:
	_go(GameManager.Mode.FIGHTING)