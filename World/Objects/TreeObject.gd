extends Node2D

onready var animPlayer = $AnimationPlayer 
onready var stumpAnimPlayer = $StumpAnimationPlayer 

var treeHits: int = 4
onready var player = get_node("/root/World/YSort/Player/Player")

onready var treeStumpSprite = $TreeSprites/TreeStump
onready var treeBottomSprite = $TreeSprites/TreeBottom
onready var treeMiddleSprite = $TreeSprites/TreeMiddle
onready var treeTopSprite = $TreeSprites/TreeTop
onready var treeShadowSprite = $TreeSprites/TreeShadow
onready var LeavesFallEffect = preload("res://Globals/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = preload("res://Globals/Effects/TrunkHitEffect.tscn")
onready var DropWoodEffect = preload("res://Globals/Effects/DropItemsEffect.tscn")

var rng = RandomNumberGenerator.new()

onready var treeTypes = ['A','B', 'C', 'D']
var treeType
func _ready():
	randomize()
	#treeTypes.shuffle()
	treeType = treeTypes[0]
	setTreeType(treeType)

func setTreeType(treeType):
	if (treeType == 'A'):
		treeStumpSprite.texture = Images.stumpNoShadowA
		treeMiddleSprite.texture = Images.middleA
		treeTopSprite.texture = Images.topA[rng.randi_range(0, Images.topA.size() - 1)]
		treeShadowSprite.texture = Images.shadowA
		treeBottomSprite.texture = Images.bottomNoShadowA
	if (treeType == 'B'):
		treeStumpSprite.texture = Images.stumpB
		treeMiddleSprite.texture = Images.middleB
		treeTopSprite.texture =Images.topB[rng.randi_range(0, Images.topB.size() - 1)]
		treeBottomSprite.texture = Images.bottomB
	if (treeType == 'C'):
		treeStumpSprite.texture = Images.stumpC
		treeMiddleSprite.texture = Images.middleC
		treeTopSprite.texture = Images.topC[rng.randi_range(0, Images.topC.size() - 1)]
		treeBottomSprite.texture = Images.bottomC
	if (treeType == 'D'):
		treeStumpSprite.texture = Images.stumpD
		treeMiddleSprite.texture = Images.middleD
		treeTopSprite.texture = Images.topD[rng.randi_range(0, Images.topD.size() - 1)]
		treeBottomSprite.texture = Images.bottomD
		
var isAnimActive: bool = false
func _on_Hurtbox_area_entered(area):
	print(player.get_position().x)
	print(get_position().x)
	if (treeHits == 0):
		#if ((player.get_position().x * 3) >= get_position().x):
		isAnimActive = true
		animPlayer.play("tree fall right")
		yield(animPlayer, "animation_finished" )
		isAnimActive = false

		var dropWoodEffect = DropWoodEffect.instance()
		var world = get_tree().current_scene
		world.add_child(dropWoodEffect)
		dropWoodEffect.global_position.x = global_position.x + 150
		dropWoodEffect.global_position.y = global_position.y - 20

		
	if (treeHits != 0):
		var leavesEffect = LeavesFallEffect.instance()
		leavesEffect.initLeavesEffect(treeType)
		var world = get_tree().current_scene
		world.add_child(leavesEffect)
		leavesEffect.global_position = global_position
		
		#if ((player.get_position().x * 3) >= get_position().x):
		var trunkHitEffect = TrunkHitEffect.instance()
		trunkHitEffect.init(treeType, "tree hit right")
		world.add_child(trunkHitEffect)
		trunkHitEffect.global_position = global_position
		#if (!isAnimActive):
		animPlayer.play("tree hit right")
		isAnimActive = true
		yield(animPlayer, "animation_finished" )
		treeHits = treeHits - 1
		isAnimActive = false


var stumpHits: int = 2

func _on_stumpHurtBox_area_entered(area):
	if (stumpHits == 0): 
		stumpAnimPlayer.play("stump_destroyed")
		var dropWoodEffect = DropWoodEffect.instance()
		var world = get_tree().current_scene
		world.call_deferred("add_child", dropWoodEffect)
		dropWoodEffect.global_position.y = global_position.y - 40
		dropWoodEffect.global_position.x = global_position.x
	if (stumpHits != 0 ):
		stumpAnimPlayer.play("stump_hit_right")
		var trunkHitEffect = TrunkHitEffect.instance()
		trunkHitEffect.init(treeType, "tree hit right")
		var world = get_tree().current_scene
		world.add_child(trunkHitEffect)
		trunkHitEffect.global_position = global_position
		stumpHits = stumpHits - 1
