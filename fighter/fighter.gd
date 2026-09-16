extends CharacterBody2D

signal health_changed(new_health: float)
signal meter_changed(new_meter: float)
signal died

enum State { NEUTRAL, STARTUP, ACTIVE, RECOVERY, HITSTUN, DEAD }

const GRAVITY := 980.0
const BODY_HALF_W := 24.0
const METER_MAX := 100.0
const HITBOX_OFFSET_X := 34.0

const AI_ATTACK_RANGE := 70.0
const AI_DECIDE_COOLDOWN := 0.35

@export var character_data: CharacterData
@export var is_player := true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D

## The opposing Fighter, assigned by the match controller after both spawn.
## Used for auto-facing (both sides) and target-seeking (CPU side only).
var opponent_ref: Node2D

var facing := 1.0
var current_health := 100.0
var current_meter := 0.0

var _state: State = State.NEUTRAL
var _state_timer := 0
var _current_move: MoveData
var _hit_landed := false
var _ai_timer := 0.0
var _punch_move: MoveData


func setup(data: CharacterData) -> void:
	character_data = data
	if character_data:
		sprite.modulate = character_data.accent_color


func _ready() -> void:
	if character_data:
		sprite.modulate = character_data.accent_color
	_punch_move = _make_punch_move()
	$Hitbox.area_entered.connect(_on_hitbox_area_entered)
	reset_for_round(global_position)


## Called by the match controller at the start of every Round.
func reset_for_round(spawn_position: Vector2) -> void:
	current_health = float(character_data.max_health) if character_data else 100.0
	current_meter = 0.0
	_state = State.NEUTRAL
	_current_move = null
	_hit_landed = false
	velocity = Vector2.ZERO
	global_position = spawn_position
	_hitbox_shape.disabled = true
	health_changed.emit(current_health)
	meter_changed.emit(current_meter)
	sprite.play(&"idle")


func _make_punch_move() -> MoveData:
	var move := MoveData.new()
	move.kind = MoveData.Kind.BASIC
	move.name = "Punch"
	move.damage = 6
	move.startup_frames = 6
	move.active_frames = 4
	move.recovery_frames = 10
	move.knockback = Vector2(140, -30)
	move.hitstun_frames = 10
	move.meter_gain = 6
	move.meter_cost = 0
	return move


func _physics_process(delta: float) -> void:
	var walk_speed := character_data.walk_speed if character_data else 215.0
	var jump_force := character_data.jump_force if character_data else 560.0
	var dir := 0.0

	if _state == State.NEUTRAL:
		if opponent_ref:
			var dx := opponent_ref.global_position.x - global_position.x
			if dx != 0.0:
				facing = sign(dx)
		if is_player:
			dir = _player_input(jump_force)
		else:
			dir = _ai_decide(delta)

	velocity.x = dir * walk_speed

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()
	position.x = clampf(position.x, BODY_HALF_W + 44.0, 1152.0 - BODY_HALF_W - 44.0)

	sprite.flip_h = facing < 0.0
	$Hitbox.position.x = HITBOX_OFFSET_X * facing

	_advance_state()
	_update_animation(dir)


func _player_input(jump_force: float) -> float:
	var dir := Input.get_axis("left", "right")
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = -jump_force

	if Input.is_action_just_pressed("light"):
		_try_attack(_punch_move, &"punch")
	elif Input.is_action_just_pressed("medium"):
		_try_attack(character_data.basic_1 if character_data else null, &"basic_1")
	elif Input.is_action_just_pressed("heavy"):
		_try_attack(character_data.basic_2 if character_data else null, &"basic_2")
	elif Input.is_action_just_pressed("special"):
		if character_data and character_data.can_use_ultimate(current_meter >= METER_MAX):
			_try_attack(character_data.ultimate, &"ultimate")

	return dir


func _ai_decide(delta: float) -> float:
	if opponent_ref == null or character_data == null:
		return 0.0

	var dx := opponent_ref.global_position.x - global_position.x
	var dist := absf(dx)

	if dist > AI_ATTACK_RANGE:
		if dist > AI_ATTACK_RANGE * 2.5 and is_on_floor() and randf() < 0.01:
			velocity.y = -character_data.jump_force
		return sign(dx)

	_ai_timer -= delta
	if _ai_timer <= 0.0 and is_on_floor():
		_ai_timer = AI_DECIDE_COOLDOWN + randf() * 0.4
		var roll := randf()
		if roll < 0.5:
			_try_attack(_punch_move, &"punch")
		elif roll < 0.85:
			_try_attack(character_data.basic_1, &"basic_1")
		else:
			_try_attack(character_data.basic_2, &"basic_2")
	return 0.0


func _try_attack(move: MoveData, anim_name: StringName) -> void:
	if move == null or _state != State.NEUTRAL or not is_on_floor():
		return
	_current_move = move
	_hit_landed = false
	_state = State.STARTUP
	_state_timer = move.startup_frames
	_play_anim(anim_name)


func _advance_state() -> void:
	match _state:
		State.STARTUP:
			_state_timer -= 1
			if _state_timer <= 0:
				_state = State.ACTIVE
				_state_timer = _current_move.active_frames
				_hitbox_shape.disabled = false
		State.ACTIVE:
			_state_timer -= 1
			if _state_timer <= 0:
				_hitbox_shape.disabled = true
				_state = State.RECOVERY
				_state_timer = _current_move.recovery_frames
		State.RECOVERY:
			_state_timer -= 1
			if _state_timer <= 0:
				_state = State.NEUTRAL
				_current_move = null
		State.HITSTUN:
			_state_timer -= 1
			if _state_timer <= 0:
				_state = State.NEUTRAL
		State.NEUTRAL, State.DEAD:
			pass


func _update_animation(dir: float) -> void:
	if _state != State.NEUTRAL:
		return
	var target := &"walk" if dir != 0.0 else &"idle"
	if sprite.animation != target:
		sprite.play(target)


func _play_anim(anim_name: StringName) -> void:
	var use := anim_name
	if sprite.sprite_frames == null or not sprite.sprite_frames.has_animation(anim_name):
		use = &"punch" if sprite.sprite_frames.has_animation(&"punch") else &"idle"
	sprite.play(use)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if _state != State.ACTIVE or _hit_landed:
		return
	var defender := area.get_parent()
	if defender == self or not defender.has_method("take_damage"):
		return
	_hit_landed = true
	defender.take_damage(_current_move, facing)

	var gain := float(_current_move.meter_gain)
	if character_data and character_data.passive == CharacterData.Passive.METER_RUSH:
		gain *= 1.25
	current_meter = clampf(current_meter + gain, 0.0, METER_MAX)
	meter_changed.emit(current_meter)


func take_damage(move: MoveData, attacker_facing: float) -> void:
	if _state == State.DEAD:
		return

	var dmg := float(move.damage)
	if character_data and character_data.passive == CharacterData.Passive.IRON_SKIN:
		dmg *= 0.9

	current_health = maxf(current_health - dmg, 0.0)
	health_changed.emit(current_health)
	velocity = Vector2(move.knockback.x * attacker_facing, move.knockback.y)

	_hitbox_shape.set_deferred("disabled", true)
	_current_move = null

	if current_health <= 0.0:
		_die()
	else:
		_state = State.HITSTUN
		_state_timer = move.hitstun_frames


func _die() -> void:
	_state = State.DEAD
	_hitbox_shape.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	died.emit()
