-- Stud-style boxing glove. Knuckles face +X, cuff opening at -X, thumb on +Z.
local SIDES = { "Top", "Bottom", "Front", "Back" }

return function(kit)
	-- Cuff
	kit:part{ name = "Cuff", size = { 3, 5.5, 6 }, pos = { -5, 4.75, 0 }, studs = SIDES }
	kit:part{ name = "Strap", color = "StrapRed", size = { 2, 5.9, 6.4 }, pos = { -5, 4.75, 0 }, studs = SIDES }
	kit:part{ name = "Strap_Label", color = "White", size = { 1.4, 1, 0.1 }, pos = { -5, 4.75, -3.25 }, studs = "none" }
	kit:part{ name = "Lining", color = "Black", size = { 0.1, 4.5, 5 }, pos = { -6.55, 4.75, 0 }, studs = "none" }

	-- Wrist (short), ramping 45° up/down into the fist
	kit:part{ name = "Wrist", size = { 1.5, 5.5, 6 }, pos = { -2.75, 4.75, 0 }, studs = SIDES }
	kit:wedge{ name = "Wrist_TopRamp", size = { 1.5, 1.5, 6 }, pos = { -2.75, 8.25, 0 }, facing = "-X" }
	kit:wedge{ name = "Wrist_BottomRamp", size = { 1, 1, 6 }, pos = { -2.5, 1.5, 0 }, facing = "-X", flip = true }

	-- Fist
	kit:part{ name = "Fist", size = { 8, 8, 7 }, pos = { 2, 5, 0 }, studs = SIDES }
	kit:part{ name = "Knuckle", size = { 1, 6, 7 }, pos = { 6.5, 5, 0 }, studs = { "Right", "Front", "Back" } }
	kit:wedge{ name = "Knuckle_Top", size = { 1, 1, 7 }, pos = { 6.5, 8.5, 0 }, facing = "+X" }
	kit:wedge{ name = "Knuckle_Bottom", size = { 1, 1, 7 }, pos = { 6.5, 1.5, 0 }, facing = "+X", flip = true }

	-- Stepped bulges top and bottom
	kit:part{ name = "TopBulge", size = { 5, 1, 7 }, pos = { 2, 9.5, 0 }, studs = { "Top", "Front", "Back" } }
	kit:wedge{ name = "TopBulge_Back", size = { 1, 1, 7 }, pos = { -1, 9.5, 0 }, facing = "-X" }
	kit:wedge{ name = "TopBulge_Front", size = { 1, 1, 7 }, pos = { 5, 9.5, 0 }, facing = "+X" }
	kit:part{ name = "BottomBulge", size = { 5, 1, 7 }, pos = { 2, 0.5, 0 }, studs = { "Bottom", "Front", "Back" } }
	kit:wedge{ name = "BottomBulge_Back", size = { 1, 1, 7 }, pos = { -1, 0.5, 0 }, facing = "-X", flip = true }
	kit:wedge{ name = "BottomBulge_Front", size = { 1, 1, 7 }, pos = { 5, 0.5, 0 }, facing = "+X", flip = true }

	-- Thumb: ~3/4 proud of the side, tip turned 45° in toward the knuckles
	kit:part{ name = "Thumb", size = { 4, 2, 2 }, pos = { 2.5, 3.5, 4 } }
	kit:part{ name = "Thumb_Tip", size = { 2, 2, 2 }, pos = { 4.8, 3.5, 3.6 }, rot = { 0, 45, 0 } }
end
