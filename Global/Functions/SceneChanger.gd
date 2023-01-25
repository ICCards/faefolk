extends CanvasLayer

onready var animation_player = $AnimationPlayer

var current_scene = null

var levels = [
	"res://World/World/World.tscn",
	"res://World/Caves/Level 1/Cave 1-1/Cave 1-1.tscn",
	"res://World/Caves/Level 1/Cave 1-2/Cave 1-2.tscn",
	"res://World/Caves/Level 1/Cave 1-3/Cave 1-3.tscn",
	"res://World/Caves/Level 1/Cave 1-4/Cave 1-4.tscn",
	"res://World/Caves/Level 1/Cave 1-5/Cave 1-5.tscn",
	"res://World/Caves/Level 1/Cave 1-6/Cave 1-6.tscn",
	"res://World/Caves/Level 1/Cave 1-7/Cave 1-7.tscn",
	"res://World/Caves/Level 1/Cave 1-Boss/Cave 1-Boss.tscn",
	"res://World/Caves/Level 1/Cave 1-Fishing/Cave 1-Fishing.tscn",
	"res://World/Caves/Level 2/Cave 2-1/Cave 2-1.tscn",
	"res://World/Caves/Level 2/Cave 2-2/Cave 2-2.tscn",
	"res://World/Caves/Level 2/Cave 2-3/Cave 2-3.tscn",
	"res://World/Caves/Level 2/Cave 2-4/Cave 2-4.tscn",
	"res://World/Caves/Level 2/Cave 2-5/Cave 2-5.tscn",
	"res://World/Caves/Level 2/Cave 2-6/Cave 2-6.tscn",
	"res://World/Caves/Level 2/Cave 2-7/Cave 2-7.tscn",
	"res://World/Caves/Level 2/Cave 2-Boss/Cave 2-Boss.tscn"
]

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	animation_player.play_backwards("fade")
	print_stray_nodes()


func advance_cave_level(current_scene, going_downwards):
	destroy_current_scene()
	var index = levels.find(current_scene)
	if going_downwards:
		PlayerData.spawn_at_cave_entrance = true
		index += 1
	else:
		PlayerData.spawn_at_cave_exit = true
		index -= 1
	yield(get_tree().create_timer(1.0), "timeout")
	goto_scene(levels[index])

func respawn():
	Server.world.is_changing_scene = true
	Server.player_node.destroy()
	for node in Server.world.get_node("Projectiles").get_children():
		node.destroy()
	for node in Server.world.get_node("Enemies").get_children():
		node.destroy(false)
	for node in Server.world.get_node("NatureObjects").get_children():
		node.queue_free()
	for node in Server.world.get_node("ForageObjects").get_children():
		node.queue_free()
	for node in Server.world.get_node("GrassObjects").get_children():
		node.queue_free()
	PlayerData.spawn_at_respawn_location = true
	yield(get_tree().create_timer(1.0), "timeout")
	goto_scene(PlayerData.player_data["respawn_scene"])
	
func destroy_current_scene():
	Server.world.is_changing_scene = true
	Server.player_node.destroy()
	for node in Server.world.get_node("Projectiles").get_children():
		node.destroy()
	for node in Server.world.get_node("Enemies").get_children():
		node.destroy(false)
	for node in Server.world.get_node("NatureObjects").get_children():
		node.queue_free()
	for node in Server.world.get_node("ForageObjects").get_children():
		node.queue_free()
	for node in Server.world.get_node("GrassObjects").get_children():
		node.queue_free()

