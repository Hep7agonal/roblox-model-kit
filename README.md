# roblox-model-kit

Generate studded, block-style Roblox models from Luau. One repo, shared by all your games.

## Setup
1. Install [Rokit](https://github.com/rojo-rbx/rokit), then in this folder run: `rokit install`
2. Build everything: `lune run scripts/build.luau`  (or one asset: `lune run scripts/build.luau StudGlove`)
3. Preview: serve the repo root (`npx serve .` or `python -m http.server`) and open /preview/
4. Studs in Roblox: upload preview/stud.png as a Decal/Image asset, paste its
   rbxassetid:// into src/Palette.luau → studTexture, rebuild. (Empty = no stud textures.)

Check rokit.toml and scripts/setup.sh for the latest Lune/Rojo versions before first use.

## Layout
```
assets/<Name>/build.luau   model definition (source)
refs/<Name>/               sketches, photos, notes.md
src/ModelKit.luau          builder library (runs in Lune and in Roblox)
src/Palette.luau           colours, material, stud texture id
scripts/build.luau         Lune build → dist/
dist/rbx/<Name>.rbxmx      Roblox model (synced by Rojo)
dist/preview/<Name>.json   preview data (read by preview/)
preview/index.html         three.js viewer
```

## Using models in a game (pick only what you need)
Add the kit to the game repo once:
```
git submodule add https://github.com/<you>/roblox-model-kit kit
```
Then list the specific assets in the game's default.project.json. Only listed files sync:
```json
"ReplicatedStorage": {
  "$className": "ReplicatedStorage",
  "Models": {
    "$className": "Folder",
    "StudGlove": { "$path": "kit/dist/rbx/StudGlove.rbxmx" },
    "StudBat":   { "$path": "kit/dist/rbx/StudBat.rbxmx" }
  }
}
```
To update: `git submodule update --remote kit`, commit, and Rojo syncs the new versions.
Pin a game to a version by checking out a tag inside kit/.

Optional runtime builder (procedural variations in-game): add
`"ModelKit": { "$path": "kit/src" }` and call
`require(ReplicatedStorage.ModelKit.ModelKit).build("Name", require(definitionModule))`.
See examples/game.default.project.json.

## Mobile
Push to main runs .github/workflows/build.yml: it builds, commits dist/, and publishes
the preview to GitHub Pages (enable Pages → Source: GitHub Actions). Prompt Claude Code on
the web from your phone, check the Pages link, sync into Studio later at a desktop.
