class_name CharacterData
extends Resource

@export var id: String
@export var display_name: String
@export var portrait: Texture2D
@export var sprite_frames: SpriteFrames
@export var accent_color: Color = Color.WHITE # placeholder while we have no art

@export var max_health: int = 100
@export var walk_speed: float = 200.0
@export var jump_force: float = 520.0
@export var weight: float = 1.0

@export var light: MoveData
@export var medium: MoveData
@export var heavy: MoveData
@export var special: MoveData
@export var ultimate: MoveData
@export var comeback: MoveData

@export var select_sound: AudioStream
@export var voice_lines: Array[AudioStream] = []