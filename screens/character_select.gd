extends Control

const COLS := 5
const CARD_SIZE := Vector2(124, 124)

var _roster: Array[CharacterData] = []
var _cards: Array[Button] = []
var _selected_index := -1

@onready var _title: Label = $Title
@onready var _grid: GridContainer = $Grid
@onready var _selected_label: Label = $SelectedLabel
@onready var _fight_button: Button = $FightButton
@onready var _back_button: Button = $BackButton


func _ready() -> void:
	_title.text = "SELECT YOUR FIGHTER"
	_roster = Roster.all()
	_back_button.grab_focus()
	_back_button.pressed.connect(_on_back)
	_fight_button.pressed.connect(_on_fight)
	_fight_button.disabled = true
	_build_grid()
	_refresh()


func _build_grid() -> void:
	for i in _roster.size():
		var data: CharacterData = _roster[i]
		var card := Button.new()
		card.name = "Card%02d" % (i + 1)
		card.custom_minimum_size = CARD_SIZE
		card.text = "%02d\n%s" % [i + 1, data.display_name]
		card.add_theme_font_size_override("font_size", 11)
		card.pressed.connect(_on_card.bind(i))
		card.add_theme_stylebox_override("normal", _card_style(data.accent_color, false))
		card.add_theme_stylebox_override("hover", _card_style(data.accent_color.lightened(0.12), false))
		card.add_theme_stylebox_override("pressed", _card_style(data.accent_color.lightened(0.12), false))
		card.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		_grid.add_child(card)
		_cards.append(card)


func _card_style(bg: Color, _selected: bool) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg.darkened(0.4)
	sb.set_corner_radius_all(10)
	sb.content_margin_left = 6.0
	sb.content_margin_right = 6.0
	sb.content_margin_top = 4.0
	sb.content_margin_bottom = 4.0
	style_card(sb, _selected)
	return sb


func _on_card(i: int) -> void:
	_selected_index = i
	_fight_button.disabled = false
	_refresh()


func _refresh() -> void:
	for i in _cards.size():
		var data: CharacterData = _roster[i]
		var normal: StyleBoxFlat = _cards[i].get_theme_stylebox("normal") as StyleBoxFlat
		var selected := i == _selected_index
		style_card(normal, selected)
	if _selected_index >= 0:
		_selected_label.text = "Selected: %s" % _roster[_selected_index].display_name
	else:
		_selected_label.text = "Pick a fighter to enter the arena"


func style_card(sb: StyleBoxFlat, selected: bool) -> void:
	if selected:
		sb.border_color = Color(1, 0.9, 0.3)
		sb.set_border_width_all(5)
		sb.bg_color = sb.bg_color.lightened(0.45)
	else:
		sb.set_border_width_all(2)
		sb.border_color = sb.bg_color.lightened(0.5)


func _on_back() -> void:
	SceneManager.goto_scene("res://screens/main_menu.tscn")


func _on_fight() -> void:
	if _selected_index < 0:
		return
	var picked: CharacterData = _roster[_selected_index]
	GameManager.start_match(picked, null, GameManager.mode)
	SceneManager.goto_scene("res://screens/arena.tscn")