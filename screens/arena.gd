extends Node2D

@onready var _player: Node2D = $Player
@onready var _dummy: Node2D = $Dummy
@onready var _char_label: Label = $HUD/TopBar/CharLabel
@onready var _mode_label: Label = $HUD/TopBar/ModeLabel
@onready var _hint_label: Label = $HUD/TopBar/HintLabel


func _ready() -> void:
	var picked: CharacterData = GameManager.player_one
	if picked == null:
		picked = Roster.all()[0]
	_player.setup(picked)
	_dummy.setup(Roster.dummy())

	_char_label.text = "%s" % picked.display_name
	_mode_label.text = "STORY" if GameManager.mode == GameManager.Mode.STORY else "FIGHTING MODE"
	_hint_label.text = "A / D move · W jump · J basic 1 · K basic 2 · U ULT = full energy · ESC menu"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.goto_scene("res://screens/main_menu.tscn")