class_name Roster
extends RefCounted

## Placeholder roster: 15 fighters generated in code until real CharacterData
## .tres assets + art exist (Milestone M5/M10). Every entry is a CharacterData.

const FIGHTER_NAMES := [
	"Pixel Punch", "Byte-I", "Kombat Kitty", "Dragon Dino", "Robo Raccoon",
	"Noodle Ninja", "Turbo Toad", "Slime Samurai", "Cactus Champ", "Waffle Warrior",
	"Plasma Pete", "Boulder Boris", "Sparky Snek", "Giga Glare", "Chill Yeti",
]

const FIGHTER_COLORS := [
	Color(0.93, 0.20, 0.20), Color(0.20, 0.55, 0.95), Color(0.95, 0.55, 0.15),
	Color(0.20, 0.75, 0.30), Color(0.60, 0.35, 0.85), Color(0.95, 0.85, 0.20),
	Color(0.15, 0.80, 0.75), Color(0.40, 0.90, 0.60), Color(0.55, 0.70, 0.20),
	Color(0.65, 0.42, 0.22), Color(0.90, 0.25, 0.70), Color(0.55, 0.60, 0.65),
	Color(0.75, 0.95, 0.25), Color(0.35, 0.30, 0.70), Color(0.55, 0.80, 0.95),
]

## Small stat spread so each pick feels slightly different on the bench.
const FIGHTER_HP := [100, 95, 105, 110, 90, 100, 95, 100, 105, 110, 90, 115, 95, 100, 105]
const FIGHTER_SPEED := [215, 235, 225, 200, 245, 230, 220, 225, 205, 200, 240, 190, 230, 210, 215]
const FIGHTER_JUMP := [560, 590, 575, 540, 610, 600, 580, 585, 545, 540, 605, 520, 595, 565, 570]


static func all() -> Array[CharacterData]:
	var out: Array[CharacterData] = []
	for i in FIGHTER_NAMES.size():
		var cd := CharacterData.new()
		cd.id = String(FIGHTER_NAMES[i]).to_lower().replace(" ", "_")
		cd.display_name = FIGHTER_NAMES[i]
		cd.accent_color = FIGHTER_COLORS[i]
		cd.max_health = FIGHTER_HP[i]
		cd.walk_speed = FIGHTER_SPEED[i]
		cd.jump_force = FIGHTER_JUMP[i]
		cd.weight = 1.0
		out.append(cd)
	return out


static func dummy() -> CharacterData:
	var cd := CharacterData.new()
	cd.id = "training_dummy"
	cd.display_name = "Training Dummy"
	cd.accent_color = Color(0.55, 0.55, 0.62)
	cd.max_health = 100
	cd.walk_speed = 0.0
	cd.jump_force = 0.0
	cd.weight = 2.0
	return cd