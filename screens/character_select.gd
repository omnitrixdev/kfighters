extends Control

const CARD_SIZE := Vector2(96, 78)

var _roster: Array[CharacterData] = []
var _cards: Array[Button] = []
var _selected_index := -1

@onready var _title: Label = $Title
@onready var _grid: GridContainer = $Grid
@onready var _selected_label: Label = $Preview/Margin/Layout/Name
@onready var _skills_label: Label = $Preview/Margin/Layout/Skills
@onready var _preview_bg: ColorRect = $Preview/Margin/Layout/PortraitBg
@onready var _preview_portrait: TextureRect = $Preview/Margin/Layout/PortraitBg/Portrait
@onready var _preview_initial: Label = $Preview/Margin/Layout/PortraitBg/Initial
@onready var _power_bar: ProgressBar = $Preview/Margin/Layout/Stats/PowerRow/Bar
@onready var _speed_bar: ProgressBar = $Preview/Margin/Layout/Stats/SpeedRow/Bar
@onready var _technique_bar: ProgressBar = $Preview/Margin/Layout/Stats/TechniqueRow/Bar
@onready var _defense_bar: ProgressBar = $Preview/Margin/Layout/Stats/DefenseRow/Bar
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
		var cell := VBoxContainer.new()
		cell.name = "Cell%02d" % (i + 1)
		cell.custom_minimum_size = CARD_SIZE
		cell.add_theme_constant_override("separation", 2)
		cell.mouse_filter = Control.MOUSE_FILTER_IGNORE

		var card := Button.new()
		card.name = "Card%02d" % (i + 1)
		card.custom_minimum_size = Vector2(CARD_SIZE.x, CARD_SIZE.y - 18)
		card.tooltip_text = data.display_name
		card.pressed.connect(_on_card.bind(i))
		card.add_theme_stylebox_override("normal", _card_style(data.accent_color, false))
		card.add_theme_stylebox_override("hover", _card_style(data.accent_color.lightened(0.12), false))
		card.add_theme_stylebox_override("pressed", _card_style(data.accent_color.lightened(0.12), false))
		card.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		if data.portrait:
			var thumb := TextureRect.new()
			thumb.texture = data.portrait
			thumb.mouse_filter = Control.MOUSE_FILTER_IGNORE
			thumb.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			thumb.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			thumb.set_anchors_preset(Control.PRESET_FULL_RECT)
			card.add_child(thumb)
		else:
			card.text = "%02d" % (i + 1)
			card.add_theme_font_size_override("font_size", 14)
		cell.add_child(card)

		var label := Label.new()
		label.text = data.display_name.to_upper()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.clip_text = true
		label.add_theme_font_size_override("font_size", 10)
		cell.add_child(label)

		_grid.add_child(cell)
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
		var normal: StyleBoxFlat = _cards[i].get_theme_stylebox("normal") as StyleBoxFlat
		var selected := i == _selected_index
		style_card(normal, selected)
	if _selected_index >= 0:
		var data: CharacterData = _roster[_selected_index]
		_selected_label.text = data.display_name.to_upper()
		var lines: Array[String] = []
		lines.append("J — %s (DMG %d)" % [data.basic_1.name, data.basic_1.damage])
		lines.append("K — %s (DMG %d)" % [data.basic_2.name, data.basic_2.damage])
		lines.append("U — %s (DMG %d) — needs FULL energy" % [data.ultimate.name, data.ultimate.damage])
		_skills_label.text = "\n".join(lines)
		_preview_bg.color = data.accent_color
		_preview_portrait.texture = data.portrait
		_preview_initial.visible = data.portrait == null
		_preview_initial.text = data.display_name.substr(0, 1).to_upper()

		var fill := StyleBoxFlat.new()
		fill.bg_color = data.accent_color
		fill.set_corner_radius_all(3)
		for bar in [_power_bar, _speed_bar, _technique_bar, _defense_bar]:
			bar.add_theme_stylebox_override("fill", fill)
		_power_bar.value = _stat_power(data)
		_speed_bar.value = _stat_speed(data)
		_technique_bar.value = _stat_technique(data)
		_defense_bar.value = _stat_defense(data)
	else:
		_selected_label.text = "Pick a fighter to enter the arena"
		_skills_label.text = ""
		_preview_bg.color = Color(0.2, 0.2, 0.24)
		_preview_portrait.texture = null
		_preview_initial.visible = true
		_preview_initial.text = "?"
		for bar in [_power_bar, _speed_bar, _technique_bar, _defense_bar]:
			bar.value = 0.0


## Stat bars are flavor readouts derived from combat data — there's no
## dedicated "technique"/"defense" field on CharacterData.
func _stat_power(data: CharacterData) -> float:
	return clampf(remap(float(data.basic_2.damage), 8.0, 36.0, 10.0, 100.0), 10.0, 100.0)


func _stat_speed(data: CharacterData) -> float:
	return clampf(remap(data.walk_speed, 90.0, 245.0, 10.0, 100.0), 10.0, 100.0)


func _stat_technique(data: CharacterData) -> float:
	var avg_startup := (data.basic_1.startup_frames + data.basic_2.startup_frames) / 2.0
	return clampf(remap(avg_startup, 4.0, 13.0, 100.0, 10.0), 10.0, 100.0)


func _stat_defense(data: CharacterData) -> float:
	return clampf(remap(float(data.max_health), 90.0, 120.0, 10.0, 100.0), 10.0, 100.0)


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