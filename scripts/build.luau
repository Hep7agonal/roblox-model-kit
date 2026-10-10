-- Usage: lune run scripts/build.luau [AssetName]   (run from repo root)
local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local ModelKit = require("../src/ModelKit")

for _, dir in { "dist", "dist/rbx", "dist/preview" } do
	if not fs.isDir(dir) then
		fs.writeDir(dir)
	end
end

local only = process.args[1]
local built = {}

for _, name in fs.readDir("assets") do
	local path = "assets/" .. name .. "/build.luau"
	if fs.isFile(path) and (only == nil or only == name) then
		local definition = luau.load(fs.readFile(path), { debugName = path })()
		local model, data = ModelKit.build(name, definition)
		fs.writeFile("dist/rbx/" .. name .. ".rbxmx", roblox.serializeModel({ model }, true))
		fs.writeFile("dist/preview/" .. name .. ".json", serde.encode("json", data, true))
		table.insert(built, name)
		print(string.format("built %s (%d parts)", name, #data.parts))
	end
end

if only and #built == 0 then
	error("No asset named " .. only .. " (expected assets/" .. only .. "/build.luau)")
end

-- Refresh the preview index from everything in dist/preview
local index = {}
for _, file in fs.readDir("dist/preview") do
	local n = string.match(file, "^(.+)%.json$")
	if n and n ~= "index" then
		table.insert(index, n)
	end
end
table.sort(index)
fs.writeFile("dist/preview/index.json", serde.encode("json", index, true))
