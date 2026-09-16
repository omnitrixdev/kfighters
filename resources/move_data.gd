class_name MoveData
extends Resource

enum Kind { BASIC, ULTIMATE }

@export var kind: Kind = Kind.BASIC
@export var name: String
@export var animation: String
@export var damage: int = 8
@export var startup_frames: int = 6
@export var active_frames: int = 3
@export var recovery_frames: int = 10
@export var knockback: Vector2 = Vector2(120, -40)
@export var hitstun_frames: int = 14
@export var meter_gain: int = 8
@export var meter_cost: int = 0
@export var hit_sfx: AudioStream