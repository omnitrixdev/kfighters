extends CharacterBody2D

@export var character_data: CharacterData
@export var is_player := true

const GRAVITY := 980.0
const BODY_HALF_W := 24.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var facing := 1.0
var _was_up := false
var _is_attacking := false


func setup(data: CharacterData) -> void:
	character_data = data
	if character_data:
		sprite.modulate = character_data.accent_color


func _ready() -> void:
	if character_data:
		sprite.modulate = character_data.accent_color
	sprite.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	if sprite.animation == &"punch":
		_is_attacking = false


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

		if Input.is_action_just_pressed("light") and not _is_attacking and is_on_floor():
			_is_attacking = true
			sprite.play(&"punch")

	velocity.x = dir * walk_speed

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()

	position.x = clampf(position.x, BODY_HALF_W + 44.0, 1152.0 - BODY_HALF_W - 44.0)

	if dir != 0.0:
		facing = sign(dir)
		sprite.flip_h = facing < 0.0

	if not _is_attacking:
		var target := &"walk" if dir != 0.0 else &"idle"
		if sprite.animation != target:
			sprite.play(target)