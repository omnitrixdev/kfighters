extends Node2D

const ROUND_INTRO_DELAY := 1.0
const FIGHT_HOLD := 0.6
const ROUND_END_DELAY := 1.4
const MATCH_END_DELAY := 2.0

@onready var _player: Node2D = $Player
@onready var _opponent: Node2D = $Opponent

@onready var _mode_label: Label = $HUD/CenterTop/ModeLabel
@onready var _round_label: Label = $HUD/CenterTop/RoundLabel
@onready var _message_label: Label = $HUD/MessageLabel
@onready var _hint_label: Label = $HUD/HintLabel

@onready var _player_name: Label = $HUD/PlayerPanel/Name
@onready var _player_health: ProgressBar = $HUD/PlayerPanel/Health
@onready var _player_energy: ProgressBar = $HUD/PlayerPanel/Energy

@onready var _opp_name: Label = $HUD/OpponentPanel/Name
@onready var _opp_health: ProgressBar = $HUD/OpponentPanel/Health
@onready var _opp_energy: ProgressBar = $HUD/OpponentPanel/Energy

var _player_data: CharacterData
var _opponent_data: CharacterData
var _player_wins := 0
var _opponent_wins := 0
var _round_number := 1
var _round_over := false


func _ready() -> void:
	_player_data = GameManager.player_one if GameManager.player_one else Roster.all()[0]
	_opponent_data = GameManager.opponent if GameManager.opponent else Roster.dummy()

	_mode_label.text = "STORY MODE" if GameManager.mode == GameManager.Mode.STORY else "FIGHTING MODE"
	_hint_label.text = "A/D move · W jump · J punch · K basic1 · L basic2 · U ultimate · ESC menu"

	_player.opponent_ref = _opponent
	_opponent.opponent_ref = _player

	_player.health_changed.connect(func(v): _player_health.value = v)
	_player.meter_changed.connect(func(v): _player_energy.value = v)
	_player.died.connect(func(): _on_round_end(false))

	_opponent.health_changed.connect(func(v): _opp_health.value = v)
	_opponent.meter_changed.connect(func(v): _opp_energy.value = v)
	_opponent.died.connect(func(): _on_round_end(true))

	_apply_fighter_data(_player, _player_data, _player_name, _player_health, _player_energy)
	_apply_fighter_data(_opponent, _opponent_data, _opp_name, _opp_health, _opp_energy)

	_start_match()


func _apply_fighter_data(fighter: Node2D, data: CharacterData, name_label: Label,
		health_bar: ProgressBar, energy_bar: ProgressBar) -> void:
	fighter.setup(data)
	name_label.text = data.display_name.to_upper()
	health_bar.max_value = float(data.max_health)
	energy_bar.max_value = 100.0


func _start_match() -> void:
	_player_wins = 0
	_opponent_wins = 0
	_round_number = 1
	await _start_round()


func _start_round() -> void:
	_round_over = false
	_round_label.text = "ROUND %d" % _round_number
	_player.reset_for_round(Vector2(260, 500))
	_opponent.reset_for_round(Vector2(890, 500))
	await _show_message("ROUND %d" % _round_number, ROUND_INTRO_DELAY)
	await _show_message("FIGHT!", FIGHT_HOLD)


func _on_round_end(player_won: bool) -> void:
	if _round_over:
		return
	_round_over = true
	if player_won:
		_player_wins += 1
	else:
		_opponent_wins += 1

	var wins_needed := int(ceil(GameManager.MAX_ROUNDS / 2.0))
	if _player_wins >= wins_needed or _opponent_wins >= wins_needed:
		await _end_match(_player_wins > _opponent_wins)
	else:
		await _show_message("ROUND WIN" if player_won else "ROUND LOST", ROUND_END_DELAY)
		_round_number += 1
		await _start_round()


func _end_match(player_won: bool) -> void:
	await _show_message("YOU WIN!" if player_won else "YOU LOSE", MATCH_END_DELAY)

	if GameManager.mode == GameManager.Mode.STORY and player_won:
		var next: CharacterData = GameManager.advance_story()
		if next != null:
			_opponent_data = next
			_apply_fighter_data(_opponent, _opponent_data, _opp_name, _opp_health, _opp_energy)
			_start_match()
			return
		await _show_message("STORY CLEAR!", MATCH_END_DELAY)

	SceneManager.goto_scene("res://screens/main_menu.tscn")


func _show_message(text: String, hold_seconds: float) -> void:
	_message_label.text = text
	_message_label.visible = true
	await get_tree().create_timer(hold_seconds).timeout
	_message_label.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.goto_scene("res://screens/main_menu.tscn")
