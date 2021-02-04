local S = minetest.get_translator("foodblocks")

--[[ regfoodblock
Register a whole cube food block.
By default it will have have a 1 wide x 3 high texture sheet.
In vertical order: top, then sides, then bottom.
 name: the internal name for the block and prefix for its texture *_cube.png
 desc: the displayed name for the block, which will be localised
 ingredient: the food used to craft the block and that it drops
 customtiles: use the provided tiles for a texture instead of the sheet
 --]]
local function regfoodblock(name, desc, ingredient, customtiles)
	local tile_sides = name..'_cube.png^[sheet:1x3:0,1'
	local node_name = "foodblocks:"..name.."_cube"
	local tiles
	if customtiles then
		tiles = customtiles
	else
		tiles = {
			name..'_cube.png^[sheet:1x3:0,0', -- top
			name..'_cube.png^[sheet:1x3:0,2', -- bottom
			tile_sides,
			tile_sides,
			tile_sides,
			tile_sides,
		}
	end
	minetest.register_node(node_name, {
		description = S("@1 Block", S(desc)),
		drop = string.format('"%s" 9', ingredient),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		drawtype = 'normal',
		paramtype2 = "facedir",
		tiles = tiles,
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
regfoodblock("blueberry", "Blueberry", "default:blueberries")

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

local function reg_capsicum(colourname, desc, ingredient, multi_color)
	local s_multi = "^[multiply:"..multi_color
	local tile_sides = "foodblocks_capsicum_base.png^[sheet:1x3:0,1" .. s_multi
	regfoodblock("capsicum_"..colourname, desc.." Capsicum", ingredient, {
		-- top
		"foodblocks_capsicum_base.png^[sheet:1x3:0,0"..s_multi.."^foodblocks_capsicum_stalk.png",
		-- bottom 
		"foodblocks_capsicum_base.png^[sheet:1x3:0,2"..s_multi,
		-- sides 
		tile_sides, tile_sides, tile_sides, tile_sides
	})
end

-- Redo + Undo
if ffork >= 1 then
	regfoodblock("beetroot", "Beetroot", "farming:beetroot")
	regfoodblock("blackberry", "Blackberry", "farming:blackberry")
	regfoodblock("blueberry", "Blueberry", "farming:blueberries")
	-- Problem: Should there be 2 or 1 kind of blueberry cube, and if one then 
	-- what/which kind(s) of blueberries should it revert to?
	minetest.register_craft({
		output = "foodblocks:blueberry_cube",
		recipe = {
			{"farming:blueberries", "farming:blueberries", "farming:blueberries"},
			{"farming:blueberries", "farming:blueberries", "farming:blueberries"},
			{"farming:blueberries", "farming:blueberries", "farming:blueberries"},
		}
	})
	regfoodblock("cabbage", "Cabbage", "farming:cabbage")
	regfoodblock("carrot", "Carrot", "farming:carrot")
	regfoodblock("chili", "Chili", "farming:chili_pepper")
	regfoodblock("corn", "Corn", "farming:corn")
	regfoodblock("cucumber", "Cucumber", "farming:cucumber")
	regfoodblock("garlic", "Garlic", "farming:garlic")
	regfoodblock("lettuce", "Lettuce", "farming:lettuce")
	regfoodblock("onion", "Onion", "farming:onion")
	reg_capsicum("g", "Green", "farming:pepper", "#87a644")
	reg_capsicum("y", "Yellouw", "farming:pepper_y", "#ffdc17")
	reg_capsicum("r", "Red", "farming:pepper_r", "#f83f3f")
	regfoodblock("pineapple", "Pineapple", "farming:pineapple")
	regfoodblock("potato", "Potato", "farming:potato", {"potato_cube.png"})
	regfoodblock("raspberry", "Raspberry", "farming:raspberries")
	regfoodblock("tomato", "Tomato", "farming:tomato")
end

-- Undo only
-- artichoke, barley, oregano, parsley, tigernuts and toadskin melons (v20201213)
if ffork >= 2 then
	regfoodblock("artichoke", "Artichoke", "farming:artichoke")
end

-- Stuff from ethereal: orange, lemon, olive, banana, strawberry
if minetest.get_modpath("ethereal") then
	regfoodblock("banana", "Banana", "ethereal:banana")
	regfoodblock("orange", "Orange", "ethereal:orange")
	regfoodblock("lemon", "Lemon", "ethereal:lemon")
	regfoodblock("strawberry", "Strawberry", "ethereal:strawberry")
end
