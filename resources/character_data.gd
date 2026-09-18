class_name CharacterData
extends Resource

## Always-on stat modifier drawn from a small shared pool (see CONTEXT.md).
## SWIFT and VITALITY are baked into walk_speed/max_health at roster build time;
## METER_RUSH and IRON_SKIN are applied at combat resolution time in fighter.gd.
enum Passive { METER_RUSH, SWIFT, IRON_SKIN, VITALITY }

@export var id: String
@export var display_name: String
@export var portrait: Texture2D
@export var sprite_frames: SpriteFrames
@export var sprite_scale: Vector2 = Vector2(0.17, 0.17)
@export var sprite_offset: Vector2 = Vector2(0, -10)
@export var accent_color: Color = Color.WHITE # placeholder while we have no art
@export var passive: Passive = Passive.METER_RUSH

@export var max_health: int = 100
@export var walk_speed: float = 200.0
@export var jump_force: float = 520.0
@export var weight: float = 1.0

@export var basic_1: MoveData
@export var basic_2: MoveData
@export var ultimate: MoveData

func can_use_ultimate(energy_full: bool) -> bool:
	return ultimate != null and energy_full

@export var select_sound: AudioStream
@export var voice_lines: Array[AudioStream] = []