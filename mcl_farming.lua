local regfoodblock = foodblocks.regfoodblock

if minetest.get_modpath("mcl_sounds") then
    _foodblocks.wood_sounds = mcl_sounds.node_sound_wood_defaults()
end

local melondef = minetest.registered_nodes["mcl_farming:melon"]

local extra_node_def = {
    groups = melondef.groups,
    _mcl_blast_resistance = melondef._mcl_blast_resistance,
    _mcl_hardness = melondef._mcl_hardness,
    _mcl_silk_touch_drop = true,
}
_foodblocks.node_groups = minetest.registered_nodes["mcl_farming:melon"].groups

regfoodblock("beetroot", "Beetroot", "mcl_farming:beetroot_item", nil,
    extra_node_def)
regfoodblock("carrot", "Carrot", "mcl_farming:carrot_item", nil, extra_node_def)
regfoodblock("potato", "Potato", "mcl_farming:potato_item", {"potato_cube.png"},
    extra_node_def)
