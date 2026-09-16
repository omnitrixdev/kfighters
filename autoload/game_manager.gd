extends Node

enum Mode { FIGHTING, STORY, QUEST }

const MAX_ROUNDS := 3

var mode: Mode = Mode.FIGHTING
var player_one: CharacterData
var opponent: CharacterData
var round_index: int = 0


func start_match(p1: CharacterData, p2: CharacterData, p_mode: Mode) -> void:
	player_one = p1
	opponent = p2
	mode = p_mode
	round_index = 0
