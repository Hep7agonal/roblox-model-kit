-- Builds a Roblox Model from a definition function. Runs in Lune (build) and in Roblox (runtime).
local IS_ROBLOX = typeof(game) == "Instance"
local R = if IS_ROBLOX
	then { Instance = Instance, Vector3 = Vector3, CFrame = CFrame, Color3 = Color3, Enum = Enum }
	else require("@lune/roblox")
local Palette = if IS_ROBLOX then require(script.Parent.Palette) else require("./Palette")

local ALL_FACES = { "Top", "Bottom", "Front", "Back", "Left", "Right" }
-- WedgePart slope faces -Z by default; rotate about Y so it faces the requested axis.
local FACING = { ["-Z"] = 0, ["+X"] = -math.pi / 2, ["-X"] = math.pi / 2, ["+Z"] = math.pi }

local function resolveColor(c)
	if type(c) == "string" then
		local rgb = Palette.colors[c]
		assert(rgb, "Unknown palette colour: " .. c)
		return rgb
	end
	return c
end

local function resolveFaces(s)
	if s == nil or s == "all" then
		return table.clone(ALL_FACES)
	elseif s == "none" then
		return {}
	end
	return s
end

local Builder = {}
Builder.__index = Builder

function Builder:_add(class, spec, size, rot)
	assert(spec.name, class .. " needs a name")
	assert(spec.size and spec.pos, spec.name .. " needs size and pos")
	local rgb = resolveColor(spec.color or Palette.default)
	local material = spec.material or Palette.material
	local studs = resolveFaces(spec.studs)

	table.insert(self.parts, {
		name = spec.name, class = class, size = size, pos = spec.pos, rot = rot,
		color = string.format("#%02x%02x%02x", rgb[1], rgb[2], rgb[3]),
		material = material, studs = studs,
	})

	local p = R.Instance.new(class)
	p.Name = spec.name
	p.Anchored = true
	p.Size = R.Vector3.new(size[1], size[2], size[3])
	p.CFrame = R.CFrame.new(spec.pos[1], spec.pos[2], spec.pos[3]) * R.CFrame.Angles(rot[1], rot[2], rot[3])
	p.Color = R.Color3.fromRGB(rgb[1], rgb[2], rgb[3])
	p.Material = R.Enum.Material[material]
	p.TopSurface = R.Enum.SurfaceType.Smooth
	p.BottomSurface = R.Enum.SurfaceType.Smooth
	if Palette.studTexture ~= "" then
		for _, face in studs do
			local t = R.Instance.new("Texture")
			t.Name = "Studs_" .. face
			t.Texture = Palette.studTexture
			t.Face = R.Enum.NormalId[face]
			t.StudsPerTileU = 1
			t.StudsPerTileV = 1
			t.Parent = p
		end
	end
	p.Parent = self.model
	return p
end

function Builder:part(spec)
	local r = spec.rot or { 0, 0, 0 }
	return self:_add("Part", spec, spec.size, { math.rad(r[1]), math.rad(r[2]), math.rad(r[3]) })
end

function Builder:wedge(spec)
	local facing = spec.facing or "-Z"
	local yaw = FACING[facing]
	assert(yaw ~= nil, spec.name .. ": facing must be +X, -X, +Z or -Z")
	local s = spec.size
	local size = if facing == "+X" or facing == "-X" then { s[3], s[2], s[1] } else { s[1], s[2], s[3] }
	return self:_add("WedgePart", spec, size, { 0, yaw, if spec.flip then math.pi else 0 })
end

local ModelKit = { Palette = Palette }

-- Returns the Model instance and a plain-data description (used for the preview JSON).
function ModelKit.build(name, definition)
	local self = setmetatable({ parts = {}, model = R.Instance.new("Model") }, Builder)
	self.model.Name = name
	definition(self)
	return self.model, { name = name, unit = "stud", parts = self.parts }
end

return ModelKit
