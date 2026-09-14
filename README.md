# Kfighters — Retro 2D Fighting Game

A data-driven 2D fighter (Tekken/Mortal Kombat-style loop, 8-bit funny aesthetic).
Single-player: **vs Bot (Fighting Mode)** and **Story Mode**. No online/netcode.
Currently all art is **placeholder colored squares** — real sprites come later.

Built with **Godot 4.7** + GDScript.

---

## How to run

1. Open the project in Godot 4.7 (`godot --editor` from this folder).
2. Press **F5** (or the Play ▶ button). The main menu loads.

### Controls

| Input | Action |
| --- | --- |
| `A` / `D` or `←` / `→` | Move left / right |
| `W` / `↑` | Jump |
| `ESC` | Back to main menu |
| `J` `K` `L` `U` | Attack buttons (reserved: light / medium / heavy / special) |

---

## Current flow

```
Main Menu ──┬─> Story Mode ──┐
            ├─> Fighting Mode┼─> Character Select (15 fighters) ──> Arena (move + jump)
            └─> Quest (daily check-in) — coming soon (Milestone M9)
```

---

## Milestones (the plan)

| # | Milestone | Status |
| - | --------- | ------ |
| M0 | **Skeleton**: project + 4 autoloads, menu/select/arena scenes, scene switching | ✅ done |
| M1 | **One fighter moves**: walk left/right, jump, gravity, stage bounds, training dummy | ✅ done |
| M2 | **Combat basics**: light attack with hitbox/hurtbox → damage → health bar → hitstun → block → KO + win/lose | ⬜ next |
| M3 | **Full moveset + P2**: light/med/heavy/special from data, round system (best of 3) + timer | ⬜ |
| M4 | **Meter & specials**: energy bar fills, ultimate at full, comeback move under 20% HP | ⬜ |
| M5 | **Character select grid**: characters as `.tres` data, portraits, per-character select SFX | ⬜ |
| M6 | **Bot AI**: reactive bot (Easy/Med/Hard) wired to Fighting Mode | ⬜ |
| M7 | **Story mode**: linear map, sequential monster fights, boss, saved progress | ⬜ |
| M8 | **Polish / juice**: hitstop, screen shake, particles, music, full SFX pass | ⬜ |
| M9 | **Meta**: save system + daily check-in unlocks (the menu's disabled Quest button) | ⬜ |
| M10 | **Scale to 15**: mass-produce remaining characters as data + sprites, balance pass | ⬜ |

> Do **not** start M10 until M1–M4 feel good with 2–3 characters.

---

## Architecture notes

### Data-driven characters

Every fighter is a `CharacterData` resource (`resources/character_data.gd`) with stats
(max_health, walk_speed, jump_force, weight), moves (`MoveData`), and identity
(display name, accent color, later portrait + sprite frames + voice lines). Adding a
character means creating data, **not** code.

For now the 15-fighter roster lives in `data/roster.gd` (code-generated placeholders,
`accent_color` drives the square). Milestone M5 converts these into `.tres` files.

### Fighter role model

`fighter/fighter.tscn` = `CharacterBody2D` whose placeholder look is drawn in
`_draw()` (a colored square with eyes showing facing). Player input and physics live
in `fighter/fighter.gd`. Combat state machine (idle/walk/jump/attack/hitstun…) sits
on top of this at M2+.

### Screens

- `screens/main_menu.tscn` — Story / Fighting / Quest (disabled)
- `screens/character_select.tscn` — 5×3 grid, pick one, then FIGHT!
- `screens/arena.tscn` — the fight stage (ground, player + training dummy, HUD)

### Autoloads

- `game_manager.gd` — current mode + picked character, round state
- `scene_manager.gd` — scene transitions
- `save_manager.gd` — persistence (stub, M9)
- `audio_manager.gd` — SFX/music (stub, M4+)

---

## Project structure

```
res://
├── autoload/               # singletons
├── data/roster.gd          # 15 placeholder fighters (CharacterData)
├── resources/              # character_data.gd, move_data.gd
├── fighter/                # fighter.tscn (CharacterBody2D) + fighter.gd
├── screens/                # main_menu, character_select, arena
└── addons/godot_mcp/       # MCP bridge for the Godot editor (dev tool)
```

## Roadmap highlights

- **Facing:** flipping the sprite must also flip hitbox positions, or attacks whiff on cross-up.
- **Hitbox active only during active frames** — a classic bug is leaving hitboxes on during recovery.
- **One hit per move** — track already-hit hurtboxes so a punch doesn't tick every frame.
- **Balance is data, not code** — tune damage in `.tres`, never in GDScript.