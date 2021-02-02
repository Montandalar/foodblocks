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

regfoodblock("corn", "Corn", "farming:corn")
regfoodblock("apple", "Apple", "default:apple")
regfoodblock("cabbage", "Cabbage", "farming:cabbage")