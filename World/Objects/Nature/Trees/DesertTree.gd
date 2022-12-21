extends Node2D

var rng = RandomNumberGenerator.new()
onready var tween: Tween = $Tween
onready var tree_animation_player = $AnimationPlayer
var destroyed: bool = false
var health
var treeObject
var adjusted_leaves_falling_pos
var location

onready var LeavesFallEffect = load("res://World/Objects/Nature/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = load("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = load("res://InventoryLogic/ItemDrop.tscn")

var desertTrees = ["1a", "1b", "2a", "2b"]

#func _ready():
#	randomize()
#	desertTrees.shuffle()
#	treeObject = Images.returnDesertTree(desertTrees[0])
#	$AnimatedSprite.frames = Images.returnDesertTree(desertTrees[0])
#	if desertTrees[0] == "2a" or desertTrees[0] == "2b":
#		$AnimatedSprite.position = Vector2(0, 20)
#	else:
#		$AnimatedSprite.position = Vector2(0, 12)

func hit(tool_name):
	health -= Stats.return_tool_damage(tool_name)
	MapData.update_object_health("tree", name, health)
	var data = {"id": name, "n": "tree"}
	Server.action("ON_HIT", data)
	health -= 1
	if health >= 1:
		#initiateLeavesFallingEffect(treeObject)
		$SoundEffects.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		if Server.player_node.get_position().x <= get_position().x:	
			#initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
			tree_animation_player.play("tree hit right")
		else: 
			#initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			tree_animation_player.play("tree hit left")
	elif not destroyed:
		destroyed = true
		disable_tree_top_collision_box()
		$SoundEffects.stream = Sounds.tree_break
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		if Server.player_node.get_position().x <= get_position().x:
			tree_animation_player.play("tree fall right")
			yield(tree_animation_player, "animation_finished" )
			InstancedScenes.intitiateItemDrop("wood", Vector2(130, -8), 7)
		else:
			tree_animation_player.play("tree fall left")
			yield(tree_animation_player, "animation_finished" )
			InstancedScenes.intitiateItemDrop("wood", Vector2(-130, -8), 7)
		MapData.remove_object("tree", name)
		Tiles.add_valid_tiles(location+Vector2(-1,0), Vector2(2,2))
		queue_free()

func disable_tree_top_collision_box():
	set_tree_visible()
	$TreeTopArea/CollisionPolygon2D.set_deferred("disabled", true)

func set_tree_visible():
	tween.interpolate_property($AnimatedSprite, "modulate",
		$AnimatedSprite.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func set_tree_transparent():
	tween.interpolate_property($AnimatedSprite, "modulate",
		$AnimatedSprite.get_modulate(), Color(1, 1, 1, 0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_TreeTopArea_area_entered(area):
	set_tree_transparent()
func _on_TreeTopArea_area_exited(area):
	set_tree_visible()


func _on_Hurtbox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.special_ability == "fire buff":
		InstancedScenes.initiateExplosionParticles(position+Vector2(rand_range(-16,16), rand_range(-18,12)))
		health -= Stats.FIRE_DEBUFF_DAMAGE
