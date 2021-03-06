extends Node

# WEAPONS #

func returnToolSprite(toolName, direction):
	match toolName:
		"pickaxe":
			match direction: 
				"swing_down":
					 return pickaxe.down
				"swing_up":
					 return pickaxe.up
				"swing_left":
					 return pickaxe.left
				"swing_right":
					 return pickaxe.right
		"axe":
			match direction: 
				"swing_down":
					 return axe.down
				"swing_up":
					 return axe.up
				"swing_left":
					 return axe.left
				"swing_right":
					return axe.right
		"hoe":
			match direction: 
				"swing_down":
					 return pickaxe.down
				"swing_up":
					 return pickaxe.up
				"swing_left":
					 return pickaxe.left
				"swing_right":
					 return pickaxe.right
					


var pickaxe = {
	down = preload("res://Characters/Weapon swings/down/pickaxe.png"), 
	up = preload("res://Characters/Weapon swings/up/pickaxe.png"), 
	left = preload("res://Characters/Weapon swings/left/pickaxe.png"), 
	right = preload("res://Characters/Weapon swings/right/pickaxe.png")
}

var axe = {
	down = preload("res://Characters/Weapon swings/down/axe.png"), 
	up =  preload("res://Characters/Weapon swings/up/axe.png"), 
	left = preload("res://Characters/Weapon swings/left/axe.png"), 
	right = preload("res://Characters/Weapon swings/right/axe.png")
}


var tall_grass = [
	preload("res://Assets/Images/tall grass sets/dark green.png"),
	preload("res://Assets/Images/tall grass sets/green.png"),
	preload("res://Assets/Images/tall grass sets/red.png"),
	preload("res://Assets/Images/tall grass sets/yellow.png")
	]
# FRUITLESS TREES #

func returnTreeObject(treeType):
	match treeType:
		"A":
			return A_tree 
		"B":
			return B_tree
		"C":
			return C_tree 
		"D":
			return D_tree 
		"E":
			return E_tree

var A_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/A/A_sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/A/1.png"),
		2 : preload("res://Assets/Images/tree_sets/A/2.png"),
		3 : preload("res://Assets/Images/tree_sets/A/3.png"),
		4 : preload("res://Assets/Images/tree_sets/A/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/A/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/A/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/A/top.png"),
	chip = preload("res://Assets/Images/tree_sets/A/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/A/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/A/large_stumpA.png"),
}

var B_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/B/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/B/1.png"),
		2 : preload("res://Assets/Images/tree_sets/B/2.png"),
		3 : preload("res://Assets/Images/tree_sets/B/3.png"),
		4 : preload("res://Assets/Images/tree_sets/B/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/B/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/B/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/B/top.png"),
	chip = preload("res://Assets/Images/tree_sets/B/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/B/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/B/large_stumpB.png"),
}

var C_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/C/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/C/1.png"),
		2 : preload("res://Assets/Images/tree_sets/C/2.png"),
		3 : preload("res://Assets/Images/tree_sets/C/3.png"),
		4 : preload("res://Assets/Images/tree_sets/C/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/C/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/C/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/C/top.png"),
	chip = preload("res://Assets/Images/tree_sets/C/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/C/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/C/large_stumpC.png"),
}

var D_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/D/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/D/1.png"),
		2 : preload("res://Assets/Images/tree_sets/D/2.png"),
		3 : preload("res://Assets/Images/tree_sets/D/3.png"),
		4 : preload("res://Assets/Images/tree_sets/D/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/D/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/D/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/D/top.png"),
	chip = preload("res://Assets/Images/tree_sets/D/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/D/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/D/large_stumpD.png"),
}

var E_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/E/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/E/1.png"),
		2 : preload("res://Assets/Images/tree_sets/E/2.png"),
		3 : preload("res://Assets/Images/tree_sets/E/3.png"),
		4 : preload("res://Assets/Images/tree_sets/E/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/E/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/E/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/E/top.png"),
	chip = preload("res://Assets/Images/tree_sets/E/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/E/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/E/large_stumpE.png"),
}


# BRANCH OBJECTS #
var tree_branch_objects = {
	0 : preload("res://Assets/Images/tree_sets/branch_objects/branch1.png"),
	1 : preload("res://Assets/Images/tree_sets/branch_objects/branch2.png"),
	2 : preload("res://Assets/Images/tree_sets/branch_objects/branch3.png"),
	3 : preload("res://Assets/Images/tree_sets/branch_objects/branch4.png"),
	4 : preload("res://Assets/Images/tree_sets/branch_objects/branch5.png"),
	5 : preload("res://Assets/Images/tree_sets/branch_objects/branch6.png"),
	6 : preload("res://Assets/Images/tree_sets/branch_objects/branch7.png"),
	7 : preload("res://Assets/Images/tree_sets/branch_objects/branch8.png"),
	8 : preload("res://Assets/Images/tree_sets/branch_objects/branch9.png"),
	9 : preload("res://Assets/Images/tree_sets/branch_objects/branch10.png"),
	10 : preload("res://Assets/Images/tree_sets/branch_objects/branch11.png"),
	11 : preload("res://Assets/Images/tree_sets/branch_objects/branch12.png"),
}


# FRUIT TREES #
func returnFruitTree(treeType):
	match treeType:
		"plum":
			return Plum_tree
		"pear":
			return Pear_tree
		"cherry":
			return Cherry_tree
		"apple":
			return Apple_tree
		
var Plum_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/plum/growing/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/plum/growing/1.png"),
		2 : preload("res://Assets/Images/tree_sets/plum/growing/2.png"),
		3 : preload("res://Assets/Images/tree_sets/plum/growing/3.png"),
		4 : preload("res://Assets/Images/tree_sets/plum/growing/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/plum/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/plum/bottom.png"),
	middleTree = preload("res://Assets/Images/tree_sets/plum/middle.png"),
	topTree = {
		0 : preload("res://Assets/Images/tree_sets/plum/tops/1.png"),
		1 : preload("res://Assets/Images/tree_sets/plum/tops/2.png"),
		2 : preload("res://Assets/Images/tree_sets/plum/tops/3.png"),
		3 : preload("res://Assets/Images/tree_sets/plum/tops/harvested.png"),
	},
	chip = preload("res://Assets/Images/tree_sets/plum/chip.png"),
	leaves = null,
}

var Pear_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/pear/growing/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/pear/growing/1.png"),
		2 : preload("res://Assets/Images/tree_sets/pear/growing/2.png"),
		3 : preload("res://Assets/Images/tree_sets/pear/growing/3.png"),
		4 : preload("res://Assets/Images/tree_sets/pear/growing/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/pear/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/pear/bottom.png"),
	middleTree = preload("res://Assets/Images/tree_sets/pear/middle.png"),
	topTree = {
		0 : preload("res://Assets/Images/tree_sets/pear/tops/1.png"),
		1 : preload("res://Assets/Images/tree_sets/pear/tops/2.png"),
		2 : preload("res://Assets/Images/tree_sets/pear/tops/3.png"),
		3 : preload("res://Assets/Images/tree_sets/pear/tops/harvested.png"),
	},
	chip = preload("res://Assets/Images/tree_sets/pear/chip.png"),
	leaves = null,
}

var Cherry_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/cherry/growing/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/cherry/growing/1.png"),
		2 : preload("res://Assets/Images/tree_sets/cherry/growing/2.png"),
		3 : preload("res://Assets/Images/tree_sets/cherry/growing/3.png"),
		4 : preload("res://Assets/Images/tree_sets/cherry/growing/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/cherry/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/cherry/bottom.png"),
	middleTree = preload("res://Assets/Images/tree_sets/cherry/middle.png"),
	topTree = {
		0 : preload("res://Assets/Images/tree_sets/cherry/tops/1.png"),
		1 : preload("res://Assets/Images/tree_sets/cherry/tops/2.png"),
		2 : preload("res://Assets/Images/tree_sets/cherry/tops/3.png"),
		3 : preload("res://Assets/Images/tree_sets/cherry/tops/harvested.png"),
	},
	chip = preload("res://Assets/Images/tree_sets/cherry/tree_chip.png"),
	leaves = null,
}

var Apple_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/apple/growing/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/apple/growing/1.png"),
		2 : preload("res://Assets/Images/tree_sets/apple/growing/2.png"),
		3 : preload("res://Assets/Images/tree_sets/apple/growing/3.png"),
		4 : preload("res://Assets/Images/tree_sets/apple/growing/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/apple/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/apple/bottom.png"),
	middleTree = preload("res://Assets/Images/tree_sets/apple/middle.png"),
	topTree = {
		0 : preload("res://Assets/Images/tree_sets/apple/tops/1.png"),
		1 : preload("res://Assets/Images/tree_sets/apple/tops/2.png"),
		2 : preload("res://Assets/Images/tree_sets/apple/tops/3.png"),
		3 : preload("res://Assets/Images/tree_sets/apple/tops/harvested.png"),
	},
	chip = preload("res://Assets/Images/tree_sets/apple/chip.png"),
	leaves = null,
}

# ORE OBJECTS #

func returnOreObject(oreType):
	match oreType:
		"Red gem":
			return Red_ore
		"Cyan gem": 
			return Cyan_ore
		"Dark blue gem":
			return Dark_blue_ore
		"Green gem":
			return Green_ore
		"Iron ore":
			return Iron_ore
		"Gold ore":
			return Gold_ore
		"Stone":
			return Stone_ore
		"Cobblestone":
			return Cobblestone_ore

var Red_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/red/red_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/red/red_chip.png")
}

var Cyan_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/cyan/cyan_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/cyan/medium/cyan_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/cyan/cyan_chip.png")
}

var Green_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/green/green_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/cyan/cyan_chip.png")
}

var Dark_blue_ore = {
	largeOre =  preload("res://Assets/Images/ore_sets/dark_blue/dark_blue_gemstone_large.png"),
	mediumOres = {
	0 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_1.png"),
	1 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_2.png"),
	2 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_3.png"),
	3 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_4.png"),
	4 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_5.png"),
	5 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/dark_blue/chip.png")
}

var Iron_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/iron/iron_gemstone_large.png"),
	mediumOres = {
	0 : preload("res://Assets/Images/ore_sets/iron/medium/iron_gemstone_1.png"),
	1 : preload("res://Assets/Images/ore_sets/iron/medium/iron_gemstone_2.png"),
	2 : preload("res://Assets/Images/ore_sets/iron/medium/iron_gemstone_3.png"),
	3 : preload("res://Assets/Images/ore_sets/iron/medium/iron_gemstone_4.png"),
	4 : preload("res://Assets/Images/ore_sets/iron/medium/iron_gemstone_5.png"),
	5 : preload("res://Assets/Images/ore_sets/iron/medium/iron_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/iron/iron_chip.png")
}

var Gold_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/gold/gold_gemstone_large.png"), 
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/gold/medium/gold_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/gold/medium/gold_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/gold/medium/gold_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/gold/medium/gold_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/gold/medium/gold_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/gold/medium/gold_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/gold/gold_chip.png")
}

var Stone_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/stone/stone_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/stone/beige_stone_chip.png")
}

var Cobblestone_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/cobblestone/cobblestone_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/cobblestone/stone_chip.png")
}

func return_house_object(item_name):
	print(item_name)
	match item_name:
		"Bed":
			return bed
		"Crafting_table": 
			return crafting_table
		"Fireplace":
			return fireplace
		"Left_chair":
			return left_chair
		"Middle_chair":
			return middle_chair
		"Painting1":
			return painting1
		"Right_chair":
			return right_chair
		"Rug":
			return rug
		"Shelves":
			return shelves
		"Side_dresser":
			return side_dresser
		"Stool":
			return stool
		"Table":
			return table
		"Window 1":
			return window1
		"Window 2":
			return window2

var bed = preload("res://Assets/Images/house_objects/bed.png")
var crafting_table = preload("res://Assets/Images/house_objects/crafting_table.png")
var fireplace = preload("res://Assets/Images/house_objects/fireplace.png")
var left_chair = preload("res://Assets/Images/house_objects/left_chair.png")
var middle_chair = preload("res://Assets/Images/house_objects/middle_chair.png")
var painting1 = preload("res://Assets/Images/house_objects/painting1.png")
var right_chair = preload("res://Assets/Images/house_objects/right_chair.png")
var rug = preload("res://Assets/Images/house_objects/rug.png")
var shelves = preload("res://Assets/Images/house_objects/shelves.png")
var side_dresser = preload("res://Assets/Images/house_objects/side_dresser.png")
var small_dresser = preload("res://Assets/Images/house_objects/small_dresser.png")
var stool = preload("res://Assets/Images/house_objects/stool.png")
var table = preload("res://Assets/Images/house_objects/table.png")
var window1 = preload("res://Assets/Images/house_objects/window 1.png")
var window2 = preload("res://Assets/Images/house_objects/window 2.png")

