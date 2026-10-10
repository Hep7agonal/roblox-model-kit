# Roblox Model Kit — rules for Claude

This repo generates blocky, studded Roblox models from Luau definitions.
Lune builds each definition into a Roblox model (.rbxmx) and a preview file (.json).

## New asset workflow
When asked for "New asset: <Name>":
1. Read every file in refs/<Name>/ (or the images attached to the prompt).
2. Sketches are authoritative for shape and proportions (1 grid square = 1 stud).
   Photos are reference for feel and colour only. Never copy proportions from photos.
3. If refs were attached instead of committed, write refs/<Name>/notes.md recording
   stud counts, proportions, colours and decisions. notes.md is the source of truth later.
4. If anything is ambiguous, ask up to 3 questions. Otherwise build.
5. Write assets/<Name>/build.luau using the ModelKit API below. Nothing else.
6. Run: lune run scripts/build.luau <Name>
7. Report: part count, overall size in studs, assumptions made.
8. Commit build.luau, refs/<Name>/ and dist/ and push to your working branch (never main),
   then give me the preview link.
9. Repeat step 8 each round of feedback. I merge to main when I approve.

Follow-ups look like "<Name>: barrel 1 stud longer". Edit only what was asked.

## Style rules
- Parts and WedgeParts only. Rotations in 45° steps only.
- Minimum part count. Flush joins, no notches or stray steps between sections.
- Bulges and rounding = stepped 45° wedges and flat facets, never curves.
- Studs on visible faces. Pass studs = "none" or a face list for hidden/overlapping faces.
- Name every part descriptively (Cuff, Knuckle_Top, Thumb_Tip…).
- Rest the model on y = 0.
- Use palette names from src/Palette.luau. Add new colours there, never inline RGB.

## Coordinates
- Units are studs. +X = forward, +Y = up, +Z = the model's left/right side.
- pos is the part centre. size is {x, y, z} in world axes (before rot).
- Roblox face names: Top +Y, Bottom -Y, Right +X, Left -X, Back +Z, Front -Z (local to the part).

## ModelKit API (inside assets/<Name>/build.luau)
```lua
return function(kit)
	kit:part{ name = "Body", size = {4, 2, 2}, pos = {0, 1, 0},
		color = "Red", rot = {0, 45, 0}, studs = {"Top", "Front", "Back"} }
	-- Wedge: slope descends toward facing ("+X", "-X", "+Z", "-Z").
	-- flip = true puts the slope underneath (for bottom chamfers).
	kit:wedge{ name = "Body_Chamfer", size = {1, 1, 2}, pos = {2.5, 1.5, 0}, facing = "+X" }
end
```
Optional fields: color (palette name, default Palette.default), material (Enum.Material
name), studs ("all" default, "none", or a face list), rot (degrees, part only).
