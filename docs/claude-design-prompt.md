# Kfighters — Claude Design Prompt

Paste the fenced block below into Claude's design tool (claude.ai → Create → Design,
on any device) to generate an interactive HTML mockup of the game's UI + art direction.
It is a self-contained prompt — Claude will not see this file.

---

```
You are designing the UI and art direction for "KFIGHTERS", a 2D side-view retro
fighting game, in a single interactive HTML mockup.

PRODUCT CONTEXT
- Genre: 2D one-on-one fighting game (Tekken/Mortal Kombat loop, but SILLY, not edgy).
- Tone: "8-bit funny" — goofy, chunky, colorful, arcade-cabinet energy. Think
  neon-on-dark, oversized type, bounce, and tiny jokes baked into the UI.
- Platform: desktop web/browser, side-view 2D, target canvas 1152x648 (16:9).
  It will be built in Godot with the GL Compatibility renderer, so designs must be
  flat 2D with ColorRect/Panel/Label-style elements and NO gradients-only effects,
  heavy shaders, or 3D. Everything must translate to simple colored shapes + text.
- Current state: fighters are placeholder colored squares with two simple eyes, so
  keep that "square with eyes" motif as the character avatar in this mockup — but
  give each a distinct personality through color, shape treatment, and name.
- Controls (write these into the UI hint areas): A/D or arrows = move, W/up = jump,
  ESC = back, J/K/L/U = light/medium/heavy/special.

THE 15-FIGHTER ROSTER (each = name + accent color + one-line silly vibe):
1. Pixel Punch — hot red — pixel-tap monochrome slugger
2. Byte-I — electric blue — glitchy snarky robot kid
3. Kombat Kitty — flame orange — dramatic odorous fluffball
4. Dragon Dino — leaf green — tiny fake dragon, big ego
5. Robo Raccoon — violet purple — trash-obsessed cyborg thief
6. Noodle Ninja — mustard yellow — limber, slips everywhere
7. Turbo Toad — teal — hyper-caffeinated amphibian
8. Slime Samurai — slime green — honor held together by goo
9. Cactus Champ — olive — spiky desert brawler
10. Waffle Warrior — maple brown — breakfast-obsessed tank
11. Plasma Pete — magenta — zapping energy goof
12. Boulder Boris — slate gray — slow, unbreakable rock
13. Sparky Snek — neon lime — coiled electric noodle
14. Giga Glare — indigo — gives you The Look (and it hurts)
15. Chill Yeti — ice blue — sleepy snow monster

SCREENS TO BUILD (wire them together with click navigation in one HTML page:
main menu -> character select -> arena):

1. MAIN MENU
   - Giant "KFIGHTERS" title (chunky slab/pixel-style type, all caps, slight
     colored letter-spacing), tagline like "THE SILLY FIGHTING GAME".
   - Three big buttons: STORY MODE, FIGHTING MODE, and QUEST (daily check-in) —
     QUEST must look disabled/greyed with a small "coming soon" badge.
   - Background: dark neon arcade vibe — diagonal grid, floating platforms, subtle
     twinkle — all flat shapes and solid fills, no photos.
   - Footer: small version line ("v0.1 · M1").

2. CHARACTER SELECT (the same screen for both modes — label top-left shows mode)
   - A 5x3 grid of the 15 roster cards above. Each card: a square "fighter with
     eyes" avatar in that fighter's accent color using the "square + 2 eyes" motif,
     the fighter's name, and three tiny stat bars (HP / SPD / JMP) as simple bars —
     vary the bar lengths per fighter for personality (roughly based on tier: heavy
     slow tanks vs light speedsters).
   - Hover/selected state: bright gold glow border around the card.
   - Bottom bar: a big "FIGHT!" button (disabled until a card is selected), a small
     "BACK" button, and a caption line ("Pick your fighter").
   - The 15 roster names/colors above are the source of truth — match them exactly.

3. ARENA (in-match HUD + stage)
   - Side-view stage: flat ground line near the bottom, simple parallax background
     layers (horizon, silhouette skyline, floor pattern) in flat solid colors.
   - Top HUD: P1 health bar (left, red) vs P2 health bar (right, red), each with a
     short fighter name label and an ENERGY/meter bar (yellow) below it; center
     "ROUND 1" with round pips (●○) and a countdown timer.
   - Two fighter placeholders on stage: the "square with eyes" motif (P1 on the
     left facing right, P2 on the right facing left), slightly hatching to show
     they're placeholders.
   - A small control hint strip at the very bottom: the controls listed above.

4. STYLE TOKENS (also in the same artifact)
   - A compact "style guide" panel listing: the exact hex color palette (background,
     panel, accent, gold-select, health red, energy yellow, text), the font choices
     (use Google Fonts: a chunky pixel font like "Press Start 2P" for titles/UI and
     a readable fallback), and spacing scale — so it can be ported 1:1 to a Godot
     Theme.

CONSTRAINTS
- All in ONE interactive HTML page (no frameworks, inline CSS is fine) with the
  three screens navigable by clicking buttons. Show the style-tokens panel on a
  fourth "style" card or a toggle.
- 16:9 responsive, optimized for a 1152x648 viewport.
- Flat 2D only: solid fills, borders, simple shapes. No 3D, no photos, no
  copyrighted characters.
- Everything must read clearly at small sizes and look cohesive across the three
  screens (share colors, type, button styles).
- Keep it FUN and a little funny — it's a silly fighting game, the UI should smile.
```

---

## Tying it back to the game

The mockup's three screens map 1:1 to our Godot scenes (`main_menu.tscn`,
`character_select.tscn`, `arena.tscn`). When Claude Design returns it, extract the
style tokens (hex palette, fonts, spacing) and implement them as a Godot Theme, and
use the screen layouts as the reference for M5 (real portraits) + M8 (polish).