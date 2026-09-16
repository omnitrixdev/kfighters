# Gemini — Character Select Background Prompt

Paste the fenced block below into Google Gemini (gemini.google.com) to generate a
background image for the character select screen. Save the result at
`assets/backgrounds/character_select_bg.png` (16:9, any resolution ≥ 1152x648).

---

```
Create a background image for the character select screen of a 2D retro fighting
game called "KFIGHTERS".

STYLE
- "8-bit funny" neon arcade vibe: dark deep-navy scene with vibrant neon accents
  (hot pink, cyan, gold), flat 2D pixel-art style, clean solid shapes, no 3D,
  no photos, no realistic textures.
- Slightly goofy and playful but never busy.

COMPOSITION (16:9, landscape)
- A far background silhouette skyline of chunky retro arcade buildings/signs in
  darker tones.
- Floating neon platforms / pixel grid floor near the bottom, receding into the
  distance with a retro vanishing-point grid.
- A strong center-right "stage" area that stays open, dark and simple so user
  interface cards can be overlaid there.
- Subtle glowing light source from behind the middle area, gentle vignette
  around the edges.

HARD CONSTRAINTS
- NO text, NO letters, NO numbers, NO logos, NO watermarks.
- NO characters, fighters, people, or animals.
- Leave the central area visually calm for UI overlays (a 5x3 grid of character
  cards will be placed on top).
- Colors: deep navy (#10142B) background; accents: neon pink (#FF2E88),
  cyan (#22E6FF), gold (#FFD23F). Use these exact hexes where possible.
- Output as a photorealistic-free, flat pixel-art 2D image, 16:9 aspect ratio.
```

---

Hang-up & porting

- This background will be added as a `TextureRect` behind the picker grid
  (`screens/character_select.tscn`) in a later UI pass, replacing the current
  flat background.
- Keep the palette consistent with the Claude Design mockup (`docs/claude-design-prompt.md`)
  so menu, picker, and arena share one art direction.