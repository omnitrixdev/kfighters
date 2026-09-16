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

## Starter Cast (see CONTEXT.md): the only roster entries with real sprite art
## this milestone. Indices into FIGHTER_NAMES: Pixel Punch, Noodle Ninja, Boulder Boris.
const STARTER_INDICES := [0, 5, 11]


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
		cd.passive = (i % 4) as CharacterData.Passive
		match cd.passive:
			CharacterData.Passive.SWIFT:
				cd.walk_speed *= 1.1
			CharacterData.Passive.VITALITY:
				cd.max_health += 15
		if i == 0:
			cd.portrait = load("res://assets/fighter/idle/idle_0.png")
		_assign_moves(cd, i)
		out.append(cd)
	return out


## The 3 Starter Cast fighters (see CONTEXT.md), in FIGHTER_NAMES order.
static func starter_cast() -> Array[CharacterData]:
	var roster := all()
	var out: Array[CharacterData] = []
	for i in STARTER_INDICES:
		out.append(roster[i])
	return out


static func _move(name: String, kind: MoveData.Kind, damage: int, startup: int,
		active: int, recovery: int, knockback: Vector2, hitstun: int,
		meter_gain: int, meter_cost: int) -> MoveData:
	var md := MoveData.new()
	md.kind = kind
	md.name = name
	md.damage = damage
	md.startup_frames = startup
	md.active_frames = active
	md.recovery_frames = recovery
	md.knockback = knockback
	md.hitstun_frames = hitstun
	md.meter_gain = meter_gain
	md.meter_cost = meter_cost
	return md


static func _assign_moves(cd: CharacterData, i: int) -> void:
	var b1_n := "Staple Attack"
	var b2_n := "Big Attack"
	var u_n := "Ultimate Attack"
	var b1 := [6, 5, 3, 9, 150, -30, 12, 8]
	var b2 := [14, 10, 3, 15, 270, -70, 20, 13]
	var u := [32, 24, 5, 26, 430, -150, 42, 100]
	match i:
		0:
			b1_n = "Pixel Jab"; b2_n = "Blocky Hook"; u_n = "Giga Pixel Crush"
		1:
			b1_n = "Bit Slap"; b2_n = "Binary Uppercut"; u_n = "System.Overload()"
			b1 = [5, 4, 3, 8, 160, -40, 12, 9]
			b2 = [13, 9, 3, 14, 280, -90, 20, 14]
			u = [30, 22, 5, 24, 500, -180, 44, 100]
		2:
			b1_n = "Scratch Fury"; b2_n = "Cattitude Slam"; u_n = "Nine-Lives Crash"
			b1 = [8, 6, 4, 9, 120, -30, 13, 8]
			b2 = [16, 12, 4, 16, 250, -80, 21, 13]
			u = [34, 26, 6, 28, 440, -160, 44, 100]
		3:
			b1_n = "Tiny Tail Whip"; b2_n = "Fake Fire Breath"; u_n = "Ultra Doom Roar"
			b2 = [16, 12, 4, 17, 240, -70, 21, 14]
			u = [36, 28, 6, 30, 430, -170, 46, 100]
		4:
			b1_n = "Trashy Smack"; b2_n = "Magnet Claw"; u_n = "Garbage Nova"
			b1 = [5, 4, 3, 8, 170, -45, 12, 9]
			b2 = [12, 8, 3, 13, 290, -95, 20, 14]
			u = [28, 21, 4, 23, 510, -190, 44, 100]
		5:
			b1_n = "Noodle Slap"; b2_n = "Ramen Kick"; u_n = "Endless Lo Mein"
			b2 = [13, 9, 3, 14, 270, -90, 20, 14]
			u = [30, 22, 5, 24, 490, -180, 44, 100]
		6:
			b1_n = "Ribbit Jab"; b2_n = "Tongue Toss"; u_n = "Hyper Hop Slam"
			b2 = [15, 11, 4, 15, 250, -80, 20, 13]
			u = [32, 25, 6, 27, 460, -170, 45, 100]
		7:
			b1_n = "Goo Slice"; b2_n = "Sludge Cut"; u_n = "Mega Ooze Drive"
			b2 = [15, 11, 4, 16, 250, -75, 21, 13]
			u = [33, 26, 6, 28, 450, -160, 45, 100]
		8:
			b1_n = "Needle Poke"; b2_n = "Prickly Uppercut"; u_n = "Desert Storm Bloom"
			b1 = [7, 6, 4, 10, 130, -35, 14, 8]
			b2 = [16, 12, 4, 16, 240, -85, 22, 13]
			u = [35, 27, 6, 29, 430, -170, 46, 100]
		9:
			b1_n = "Syrup Splash"; b2_n = "Butter Slam"; u_n = "Maple Megaslam"
			b1 = [8, 7, 4, 11, 120, -25, 14, 8]
			b2 = [17, 13, 4, 17, 230, -80, 22, 13]
			u = [36, 28, 7, 30, 420, -170, 46, 100]
		10:
			b1_n = "Zap Tap"; b2_n = "Volt Hook"; u_n = "Plasma Overdrive"
			b1 = [5, 4, 3, 8, 170, -45, 12, 9]
			b2 = [12, 8, 3, 13, 300, -100, 20, 14]
			u = [29, 21, 4, 23, 520, -200, 44, 100]
		11:
			b1_n = "Rock Jab"; b2_n = "Granite Bash"; u_n = "Avalanche Crush"
			b1 = [10, 8, 5, 13, 110, -20, 16, 7]
			b2 = [19, 14, 5, 19, 220, -70, 24, 12]
			u = [40, 30, 7, 32, 400, -160, 48, 100]
		12:
			b1_n = "Forked Fang"; b2_n = "Coil Strike"; u_n = "Thunder Constructor"
			b1 = [6, 5, 3, 9, 160, -40, 13, 9]
			b2 = [13, 9, 4, 14, 280, -90, 21, 14]
			u = [31, 23, 5, 25, 480, -180, 45, 100]
		13:
			b1_n = "Mean Stare"; b2_n = "Glare Slash"; u_n = "Death Wink Ray"
			b1 = [7, 6, 3, 10, 140, -35, 13, 8]
			b2 = [15, 11, 4, 15, 260, -85, 21, 13]
			u = [33, 26, 6, 28, 460, -180, 46, 100]
		14:
			b1_n = "Snow Poke"; b2_n = "Frost Toss"; u_n = "Absolute Zero Punch"
			b1 = [8, 7, 4, 11, 130, -30, 14, 8]
			b2 = [16, 12, 4, 17, 240, -80, 22, 13]
			u = [35, 28, 6, 30, 430, -170, 46, 100]
	cd.basic_1 = _move(b1_n, MoveData.Kind.BASIC, b1[0], b1[1], b1[2], b1[3],
		Vector2(b1[4], b1[5]), b1[6], b1[7], 0)
	cd.basic_2 = _move(b2_n, MoveData.Kind.BASIC, b2[0], b2[1], b2[2], b2[3],
		Vector2(b2[4], b2[5]), b2[6], b2[7], 0)
	cd.ultimate = _move(u_n, MoveData.Kind.ULTIMATE, u[0], u[1], u[2], u[3],
		Vector2(u[4], u[5]), u[6], 0, u[7])


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
