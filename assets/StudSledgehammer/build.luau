-- Stud-style sledgehammer. Stands on the handle end; head on top, striking faces at ±X.
local R2 = math.sqrt(2)
local HEAD_Y = 16.5 -- head spans y 14..19

return function(kit)
	-- Handle runs through the head and pokes 1 stud out the top
	kit:part{ name = "Handle", color = "Wood", size = { 2, 20, 2 }, pos = { 0, 10, 0 } }

	-- Head body
	kit:part{ name = "Head", color = "Steel", size = { 10, 5, 6 }, pos = { 0, HEAD_Y, 0 },
		studs = { "Top", "Bottom", "Front", "Back" } }

	for _, side in { { s = 1, tag = "Front", face = "Right", dir = "+X" }, { s = -1, tag = "Back", face = "Left", dir = "-X" } } do
		local x = 5.5 * side.s
		-- Striking face, inset 1 stud on every edge
		kit:part{ name = "Face_" .. side.tag, color = "Steel", size = { 1, 3, 4 }, pos = { x, HEAD_Y, 0 },
			studs = { side.face } }
		-- Top / bottom bevels, same width as the striking face
		kit:wedge{ name = "Bevel_" .. side.tag .. "_Top", color = "Steel", size = { 1, 1, 4 },
			pos = { x, HEAD_Y + 2, 0 }, facing = side.dir }
		kit:wedge{ name = "Bevel_" .. side.tag .. "_Bottom", color = "Steel", size = { 1, 1, 4 },
			pos = { x, HEAD_Y - 2, 0 }, facing = side.dir, flip = true }
		-- Side bevels: 45° posts centred on the face corner lines, same height as the striking face
		kit:part{ name = "Bevel_" .. side.tag .. "_Left", color = "Steel", size = { R2, 3, R2 },
			pos = { 5 * side.s, HEAD_Y, 2 }, rot = { 0, 45, 0 }, studs = { if side.s > 0 then "Back" else "Left" } }
		kit:part{ name = "Bevel_" .. side.tag .. "_Right", color = "Steel", size = { R2, 3, R2 },
			pos = { 5 * side.s, HEAD_Y, -2 }, rot = { 0, 45, 0 }, studs = { if side.s > 0 then "Right" else "Front" } }
	end
end
