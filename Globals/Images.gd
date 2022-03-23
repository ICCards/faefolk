extends Node

#var mountain_tree_stumps = {
#	0 : preload("res://Assets/trees/mountains/stumps/stump1A.png"),
#	1 : preload("res://Assets/trees/mountains/stumps/stump1B.png"),
#	2 : preload("res://Assets/trees/mountains/stumps/stump1C.png"),
#	3 : preload("res://Assets/trees/mountains/stumps/stump2A.png"),
#	4 : preload("res://Assets/trees/mountains/stumps/stump2B.png"),
#	5 : preload("res://Assets/trees/mountains/stumps/stump2C.png"),
#}
#
#var mountain_tree_middles = {
#	0 : preload("res://Assets/trees/mountains/middles/middle1A.png"),
#	1 : preload("res://Assets/trees/mountains/middles/middle1B.png"),
#	2 : preload("res://Assets/trees/mountains/middles/middle1C.png"),
#	3 : preload("res://Assets/trees/mountains/middles/middle2A.png"),
#	4 : preload("res://Assets/trees/mountains/middles/middle2B.png"),
#	5 : preload("res://Assets/trees/mountains/middles/middle2C.png"),
#}
#
#var mountain_tree_tops = {
#	0 : preload("res://Assets/trees/mountains/tops/top1A.png"),
#	1 : preload("res://Assets/trees/mountains/tops/top1B.png"),
#	2 : preload("res://Assets/trees/mountains/tops/top1C.png"),
#	3 : preload("res://Assets/trees/mountains/tops/top2A.png"),
#	4 : preload("res://Assets/trees/mountains/tops/top2B.png"),
#	5 : preload("res://Assets/trees/mountains/tops/top2C.png"),
#}


var stumpA = preload("res://tree_sets/A/stumpA.png")
var bottomA = preload("res://tree_sets/A/bottomA.png")
var middleA = preload("res://tree_sets/A/middleA.png")
var shadowA = preload("res://tree_sets/A/shadow_A.png")
var stumpNoShadowA = preload("res://tree_sets/A/stump_no_shadow_A.png")
var bottomNoShadowA = preload("res://tree_sets/A/tree_bottom_no_shadow_A.png")
var topA = {
	0 : preload("res://tree_sets/A/tops/dark_green_fruit_tree_A .png"),
	1 : preload("res://tree_sets/A/tops/green_fruit_A.png"),
	2 : preload("res://tree_sets/A/tops/green_large_A.png"),
	3 : preload("res://tree_sets/A/tops/small_green_A.png"),
	4 : preload("res://tree_sets/A/tops/yellow_fruit_tree_A.png"), 
}
var chipA = preload("res://tree_sets/A/tree_chip_A.png")
var leaf_spritesA = preload("res://tree_sets/A/A_leaf_sprites.png")


var stumpB = preload("res://tree_sets/B/stumpB.png")
var bottomB = preload("res://tree_sets/B/bottomB.png")
var middleB = preload("res://tree_sets/B/middleB.png")
var chipB = preload("res://tree_sets/B/tree_chip_B.png")
var topB = {
	0 : preload("res://tree_sets/B/tops/blue_fruit_B.png"),
	1 : preload("res://tree_sets/B/tops/dark_green_tree_B.png"),
	2 : preload("res://tree_sets/B/tops/green_large_B.png"),
	3 : preload("res://tree_sets/B/tops/green_medium_B.png"),
	4 : preload("res://tree_sets/B/tops/green_small_B.png"), 
	5 : preload("res://tree_sets/B/tops/purple_fruit_tree_B.png"),
}

var stumpC = preload("res://tree_sets/C/stumpC.png")
var bottomC = preload("res://tree_sets/C/bottomC.png")
var middleC = preload("res://tree_sets/C/middleC.png")
var chipC = preload("res://tree_sets/C/tree_chip_C.png")
var topC = {
	0 : preload("res://tree_sets/C/tops/purple_few_red_fruit_C.png"),
	1 : preload("res://tree_sets/C/tops/purple_green_fruits.png"),
	2 : preload("res://tree_sets/C/tops/purple_large_C.png"),
	3 : preload("res://tree_sets/C/tops/purple_medium_C.png"),
	4 : preload("res://tree_sets/C/tops/purple_red_fruit.png"), 
}

var stumpD = preload("res://tree_sets/D/stumpD.png")
var bottomD = preload("res://tree_sets/D/bottomD.png")
var middleD = preload("res://tree_sets/D/middleD.png")
var chipD = preload("res://tree_sets/D/tree_chip_D.png")
var topD = {
	0 : preload("res://tree_sets/D/tops/dark_green_fruit.png"),
	1 : preload("res://tree_sets/D/tops/green_fruit_D.png"),
	2 : preload("res://tree_sets/D/tops/green_large_D.png"),
	3 : preload("res://tree_sets/D/tops/green_small_D.png"),
	4 : preload("res://tree_sets/D/tops/red_fruit_D.png"), 
}




var redOreLarge = preload("res://ore_sets/red/red_gemstone_large.png")
var redOreMediums = {
	0 : preload("res://ore_sets/red/medium/red_gemstone_1.png"),
	1 : preload("res://ore_sets/red/medium/red_gemstone_2.png"),
	2 : preload("res://ore_sets/red/medium/red_gemstone_3.png"),
	3 : preload("res://ore_sets/red/medium/red_gemstone_4.png"),
	4 : preload("res://ore_sets/red/medium/red_gemstone_5.png"),
	5 : preload("res://ore_sets/red/medium/red_gemstone_6.png"),
}
var redOreChips = {
	0 : preload("res://ore_sets/red/chips/red_chip_3.png"),
	1 : preload("res://ore_sets/red/chips/red_chip_2.png"),
}

var cyanOreLarge = preload("res://ore_sets/cyan/cyan_gemstone_large.png")
var cyanOreMediums = {
	0 : preload("res://ore_sets/cyan/medium/cyan_gemstone_1.png"),
	1 : preload("res://ore_sets/cyan/medium/teal_gemstone_2.png"),
	2 : preload("res://ore_sets/cyan/medium/teal_gemstone_3.png"),
	3 : preload("res://ore_sets/cyan/medium/teal_gemstone_4.png"),
	4 : preload("res://ore_sets/cyan/medium/teal_gemstone_5.png"),
	5 : preload("res://ore_sets/cyan/medium/teal_gemstone_6.png"),
}
var cyanOreChips = {
	0 : preload("res://ore_sets/cyan/chips/cyan_chip_3.png"),
	1 : preload("res://ore_sets/cyan/chips/cyan_chip_2.png"),
}

var greenOreLarge = preload("res://ore_sets/green/green_gemstone_large.png")
var greenOreMediums = {
	0 : preload("res://ore_sets/green/medium/green_gemstone_1.png"),
	1 : preload("res://ore_sets/green/medium/green_gemstone_2.png"),
	2 : preload("res://ore_sets/green/medium/green_gemstone_3.png"),
	3 : preload("res://ore_sets/green/medium/green_gemstone_4.png"),
	4 : preload("res://ore_sets/green/medium/green_gemstone_5.png"),
	5 : preload("res://ore_sets/green/medium/green_gemstone_6.png"),
}
var greenOreChips = {
	0 : preload("res://ore_sets/green/chips/green_chip_2.png"),
	1 : preload("res://ore_sets/green/chips/green_chip_3.png"),
}

var darkBlueOreLarge = preload("res://ore_sets/dark_blue/dark_blue_gemstone_large.png")
var darkBlueOreMediums = {
	0 : preload("res://ore_sets/dark_blue/medium/dark_blue_gemstone_1.png"),
	1 : preload("res://ore_sets/dark_blue/medium/dark_blue_gemstone_2.png"),
	2 : preload("res://ore_sets/dark_blue/medium/dark_blue_gemstone_3.png"),
	3 : preload("res://ore_sets/dark_blue/medium/dark_blue_gemstone_4.png"),
	4 : preload("res://ore_sets/dark_blue/medium/dark_blue_gemstone_5.png"),
	5 : preload("res://ore_sets/dark_blue/medium/dark_blue_gemstone_6.png"),
}
var darkBlueOreChips = {
	0 : preload("res://ore_sets/dark_blue/chips/db_chip_2.png"),
	1 : preload("res://ore_sets/dark_blue/chips/db_chip_3.png")
	
}


var ironOreLarge = preload("res://ore_sets/iron/iron_gemstone_large.png")
var ironOreMediums = {
	0 : preload("res://ore_sets/iron/medium/iron_gemstone_1.png"),
	1 : preload("res://ore_sets/iron/medium/iron_gemstone_2.png"),
	2 : preload("res://ore_sets/iron/medium/iron_gemstone_3.png"),
	3 : preload("res://ore_sets/iron/medium/iron_gemstone_4.png"),
	4 : preload("res://ore_sets/iron/medium/iron_gemstone_5.png"),
	5 : preload("res://ore_sets/iron/medium/iron_gemstone_6.png"),
}
var ironOreChips = {
	0 : preload("res://ore_sets/iron/chips/iron_chip_2.png"),
	1 : preload("res://ore_sets/iron/chips/iron_chip_3.png"),
}

var goldOreLarge = preload("res://ore_sets/gold/gold_gemstone_large.png")
var goldOreMediums = {
	0 : preload("res://ore_sets/gold/medium/gold_gemstone_1.png"),
	1 : preload("res://ore_sets/gold/medium/gold_gemstone_2.png"),
	2 : preload("res://ore_sets/gold/medium/gold_gemstone_3.png"),
	3 : preload("res://ore_sets/gold/medium/gold_gemstone_4.png"),
	4 : preload("res://ore_sets/gold/medium/gold_gemstone_5.png"),
	5 : preload("res://ore_sets/gold/medium/gold_gemstone_6.png"),
}
var goldOreChips = {
	0 : preload("res://ore_sets/gold/chips/gold_chip_2.png"),
	1 : preload("res://ore_sets/gold/chips/gold_chip_3.png"),
}

var stoneOreLarge = preload("res://ore_sets/stone/stone_gemstone_large.png")
var stoneOreMediums = {
	0 : preload("res://ore_sets/stone/medium/stone_gemstone_1.png"),
	1 : preload("res://ore_sets/stone/medium/stone_gemstone_2.png"),
	2 : preload("res://ore_sets/stone/medium/stone_gemstone_3.png"),
	3 : preload("res://ore_sets/stone/medium/stone_gemstone_4.png"),
	4 : preload("res://ore_sets/stone/medium/stone_gemstone_5.png"),
	5 : preload("res://ore_sets/stone/medium/stone_gemstone_6.png"),
}
var stoneOreChips = {
	0 : preload("res://ore_sets/stone/chips/stone_chip_2.png"),
	1 : preload("res://ore_sets/stone/chips/stone_chip_3.png"),
}

var cobblestoneOreLarge = preload("res://ore_sets/cobblestone/cobblestone_gemstone_large.png")
var cobblestoneOreMediums = {
	0 : preload("res://ore_sets/cobblestone/medium/cobblestone_gemstone_1.png"),
	1 : preload("res://ore_sets/cobblestone/medium/cobblestone_gemstone_2.png"),
	2 : preload("res://ore_sets/cobblestone/medium/cobblestone_gemstone_3.png"),
	3 : preload("res://ore_sets/cobblestone/medium/cobblestone_gemstone_4.png"),
	4 : preload("res://ore_sets/cobblestone/medium/cobblestone_gemstone_5.png"),
	5 : preload("res://ore_sets/cobblestone/medium/cobblestone_gemstone_6.png"),
}
var cobblestoneOreChips = {
	0 : preload("res://ore_sets/cobblestone/chips/cobble_chip_2.png"),
	1 : preload("res://ore_sets/cobblestone/chips/cobble_chip_3.png"),
}
