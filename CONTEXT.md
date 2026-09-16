# Kfighters

A 2D 1v1 fighting game (Godot 4.7). Single context — this file covers the whole game domain.

## Language

**Fighting Mode**:
A single match between the player's chosen fighter and a CPU-controlled opponent. The player does not pick the opponent's fighter.
_Avoid_: Versus mode, PvP (there is no local 2-player mode)

**Story Mode**:
A ladder: the player picks one fighter once, then fights a fixed sequence of CPU opponents back-to-back with no re-pick between fights.
_Avoid_: Campaign, arcade mode

**Quest Mode**:
A disabled placeholder mode (daily check-in) with no design yet. Not part of this milestone.

**Roster**:
The full list of playable `CharacterData` entries (15 total). Most are placeholder: a name, an accent color, and generated moves, but no unique sprite art.

**Starter Cast**:
The subset of the Roster that has real generated sprite art (idle/walk/punch/etc.) for the current milestone: Pixel Punch, Boulder Boris, Noodle Ninja. Every other roster entry uses the accent-color-swatch placeholder look.

**Normal Move**:
A move every fighter can perform regardless of character. Not defined per-character in `CharacterData`. For this milestone, Punch is the only Normal Move — Kick is not yet a distinct, wired move.
_Avoid_: Basic move (reserved for Basic 1 / Basic 2, see below)

**Ladder**:
Story Mode's fixed 3-fight sequence, drawn only from the Starter Cast so no placeholder swatches appear in Story Mode. With only 2 other Starter Cast members available once the player's own pick is excluded, fight 3 is a harder rematch (stat-boosted) of one of the two rather than a third distinct fighter.

**Basic 1 / Basic 2**:
A character-specific attack defined by a `MoveData` resource with `kind = BASIC`. Two per character.
_Avoid_: Special move, normal move

**Ultimate**:
A character-specific `MoveData` resource with `kind = ULTIMATE`. Requires a full energy meter to use.

**Passive Skill**:
An always-on stat modifier assigned to a character, drawn from a shared 4-type pool rather than hand-written per character: Meter Rush (+25% meter gain), Swift (+10% walk speed), Iron Skin (-10% damage taken), Vitality (+15 max HP). Assigned deterministically by `roster_index % 4`. Distinct from Basic/Ultimate moves — a passive is never activated, it's constantly in effect.

**Hitbox**:
A single generic `Area2D`, the same size/offset for every move on every character, enabled only during a move's `active_frames` window and positioned in front of the fighter. Replaces "moves always connect regardless of distance."

**Match**:
One Fighting Mode fight, or one fight within a Story Mode ladder. Always best-of-3 Rounds.

**Round**:
One of up to 3 sub-fights that make up a Match; a fighter's HP and energy meter both reset to empty/full at the start of each Round. The Match ends when one side wins 2 Rounds.

**CPU Opponent**:
The computer-controlled fighter in a Match. In Fighting Mode it's picked at random from the Roster; in Story Mode it's the next fighter in the ladder sequence. Uses simple reactive AI (approach, attack in range, occasional jump) — not a decision tree, not random button-mashing.
