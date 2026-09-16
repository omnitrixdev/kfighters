extends Node

enum Mode { FIGHTING, STORY, QUEST }

const MAX_ROUNDS := 3

var mode: Mode = Mode.FIGHTING
var player_one: CharacterData
var opponent: CharacterData
var round_index: int = 0

## Story Mode ladder state (see CONTEXT.md "Ladder"): the fixed 3-fight sequence
## built once the player picks a fighter, and the player's progress through it.
var story_ladder: Array[CharacterData] = []
var story_index: int = 0


func start_match(p1: CharacterData, p2: CharacterData, p_mode: Mode) -> void:
	mode = p_mode
	round_index = 0
	player_one = p1
	opponent = p2
	story_ladder = []
	story_index = 0

	if p1 == null:
		return

	match mode:
		Mode.STORY:
			_build_story_ladder(p1)
			opponent = story_ladder[0]
		Mode.FIGHTING:
			if opponent == null:
				opponent = _random_cpu_pick()


## Advances to the next Story Mode ladder fight. Returns the new opponent, or
## null if the ladder is complete (caller should treat that as a run-clear).
func advance_story() -> CharacterData:
	story_index += 1
	round_index = 0
	if story_index < story_ladder.size():
		opponent = story_ladder[story_index]
		return opponent
	return null


func _random_cpu_pick() -> CharacterData:
	var roster := Roster.all()
	return roster[randi() % roster.size()]


func _build_story_ladder(picked: CharacterData) -> void:
	var others: Array[CharacterData] = []
	for c in Roster.starter_cast():
		if c.id != picked.id:
			others.append(c)
	# Starter Cast has 3 members; excluding the player's pick always leaves 2.
	story_ladder = [others[0], others[1], _boosted_rematch(others[1])]


func _boosted_rematch(base: CharacterData) -> CharacterData:
	var boosted: CharacterData = base.duplicate(true)
	boosted.display_name = base.display_name + " (Rematch)"
	boosted.max_health = int(base.max_health * 1.2)
	return boosted
