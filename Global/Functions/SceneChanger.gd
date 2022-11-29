extends CanvasLayer

onready var animation_player = $AnimationPlayer

var current_scene = null

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
