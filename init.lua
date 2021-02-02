local function regfoodblock(name, desc, ingredient)
	local tile_sides = name..'_cube.png^[sheet:1x3:0,1'
	local node_name = "foodblocks:"..name.."_cube"
	minetest.register_node(node_name, {
		description = string.format("%s Cube", desc),
		drop = string.format('"%s" 9', ingredient),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		drawtype = 'normal',
		paramtype2 = "facedir",
		tiles = {
			name..'_cube.png^[sheet:1x3:0,0', -- top
			name..'_cube.png^[sheet:1x3:0,2', -- bottom
			tile_sides,
			tile_sides,
			tile_sides,
			tile_sides,
		}
	})
	
	minetest.register_craft({
		output = node_name,
		recipe = {
			{ingredient, ingredient, ingredient},
			{ingredient, ingredient, ingredient},
			{ingredient, ingredient, ingredient},
		}
	})
end

-- Default
regfoodblock("apple", "Apple", "default:apple")

-- Nothing from minetest_game farming (wheat & cotton)

-- FORK DETECTION
-- farming_undo is a fork of redo with some more stuff
local ffork = 0
if farming.mod then
	if farming.mod == "redo" then
		ffork = 1
	elseif farming.mod == "undo" then
		ffork = 2
	end
end

-- Redo + Undo
if ffork >= 1 then
	regfoodblock("corn", "Corn", "farming:corn")
	regfoodblock("cabbage", "Cabbage", "farming:cabbage")
	regfoodblock("onion", "Onion", "farming:onion")
end

-- Undo only
-- artichoke, barley, oregano, parsley, tigernuts and toadskin melons (v20201213)