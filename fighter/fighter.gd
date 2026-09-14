extends CharacterBody2D

## A placeholder fighter: a colored square that walks left/right and jumps.
## Real sprite rendering (AnimatedSprite2D + SpriteFrames) replaces _draw() later.

@export var character_data: CharacterData
@export var is_player := true

const GRAVITY := 980.0
const SIZE := 56.0
const BODY_HALF_W := 24.0

var facing := 1.0
var base_color := Color(0.55, 0.55, 0.62)
var _was_up := false


func setup(data: CharacterData) -> void:
	character_data = data
	if character_data:
		base_color = character_data.accent_color
	queue_redraw()


func _ready() -> void:
	if character_data:
		base_color = character_data.accent_color
	queue_redraw()


func _physics_process(delta: float) -> void:
	var walk_speed := character_data.walk_speed if character_data else 215.0
	var jump_force := character_data.jump_force if character_data else 560.0

	var dir := 0.0
	if is_player:
		dir = Input.get_axis("left", "right")
		var up := Input.is_action_pressed("up")
		if up and not _was_up:
			_was_up = true
			if is_on_floor():
				velocity.y = -jump_force
		elif not up:
			_was_up = false

	velocity.x = dir * walk_speed

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()

	position.x = clampf(position.x, BODY_HALF_W + 44.0, 1152.0 - BODY_HALF_W - 44.0)

	if dir != 0.0:
		facing = sign(dir)
	queue_redraw()


func _draw() -> void:
	var half := SIZE * 0.5
	draw_rect(Rect2(-half, -half, SIZE, SIZE), base_color)
	draw_rect(Rect2(-half, -half, SIZE, SIZE), base_color.darkened(0.45), false, 3.0)

	# Face: two eyes that show which way the fighter is looking.
	var ex := 10.0 * facing
	var ey := -8.0
	var r := 4.0
	draw_circle(Vector2(ex - 4.0 * facing, ey), r, Color(1, 1, 1))
	draw_circle(Vector2(ex + 4.0 * facing, ey), r, Color(1, 1, 1))
	draw_circle(Vector2(ex - 4.0 * facing, ey), r * 0.5, Color(0.1, 0.1, 0.1))
	draw_circle(Vector2(ex + 4.0 * facing, ey), r * 0.5, Color(0.1, 0.1, 0.1))