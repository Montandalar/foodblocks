local S = minetest.get_translator("foodblocks")

local drop_self = minetest.settings:get_bool("foodblocks_drop_selves", false)
local creative_mode = minetest.is_creative_enabled() or false

--[[ regfoodblock
Register a whole cube food block.
By default it will have have a 1 wide x 3 high texture sheet.
In vertical order: top, then sides, then bottom.
 name: the internal name for the block and prefix for its texture *_cube.png
 desc: the displayed name for the block, which will be localised
 ingredient: the food used to craft the block and that it drops
 customtiles: use the provided tiles for a texture instead of the sheet
 customdef: any other custom fields to put in the node definition. Will override
 any defaults set by the foodblocks code, so use with care!
--]]
local function regfoodblock(name, desc, ingredient, customtiles, customdef)
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

	local drop
	-- This wouldn't work when written as (drop_self or creative_mode).
	-- The reason was I wasn't checking for and subtiting false for nils 
	-- when assigning above!
	if drop_self or creative_mode then
		drop = node_name
	else
		drop = string.format('"%s" 9', ingredient)
	end
	minetest.log("warning", string.format("name = %s, drop = %s", name, drop))

	local node_def = {
		description = S("@1 Block", S(desc)),
		drop = drop,
		drawtype = 'normal',
		groups = _foodblocks.node_groups,
		paramtype2 = "facedir",
		sounds = _foodblocks.wood_sounds,
		tiles = tiles,
		_mcl_hardness = 1,
	}

	if customdef ~= nil and type(customdef) == "table" then
		for k,v in pairs(customdef) do
			node_def[k] = v
		end
	end

	minetest.register_node(node_name, node_def)
	
	minetest.register_craft({
		output = node_name,
		recipe = {
			{ingredient, ingredient, ingredient},
			{ingredient, ingredient, ingredient},
			{ingredient, ingredient, ingredient},
		}
	})

	minetest.register_craft({
		output = string.format('"%s" 9', ingredient),
		type = "shapeless",
		recipe = {node_name}
	})
end

-- Internal API
_foodblocks = {
	wood_sounds = {},
	node_groups = {},
}

-- External API
foodblocks = {
	regfoodblock = regfoodblock,
}
-- FORK DETECTION
-- farming_undo is a fork of redo with some more stuff

local modpath = minetest.get_modpath("foodblocks")

if minetest.get_modpath("farming") 
	and minetest.global_exists("farming")
	and farming.mod
then
	dofile(modpath.."/farming.lua")
elseif minetest.get_modpath("mcl_farming") then
	dofile(modpath.."/mcl_farming.lua")
else
	error([[
No compatible farming mod found! Please install one of the compatible mods:
Farming from Minetest Game, farming_redo by Tenplus1, farming_undo by Felfa or
mcl_farming from Mineclone2.]])
end
