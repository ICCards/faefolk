extends Node2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var entered = false
var door_open = false
var id
var location

var object_name = "gate"

var temp_health = 3

func _on_HurtBox_area_entered(area):
	if temp_health == 0:
		if area.name == "AxePickaxeSwing":
			Stats.decrease_tool_health()
		InstancedScenes.intitiateItemDrop("wood gate", position, 1)
		Tiles.add_valid_tiles(location, Vector2(2,1))
		queue_free()
	else:
		temp_health -= 1
		$AnimationPlayer.play("shake")

func toggle_gate():
	if door_open:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorOpen.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
		sound_effects.play()
		$Gate.frame = 0
		$MovementCollision/CollisionShape2D.set_deferred("disabled", false)
	else:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorClose.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
		sound_effects.play()
		$Gate.frame = 1
		$MovementCollision/CollisionShape2D.set_deferred("disabled", true)
	door_open = !door_open


#func _input(event):
#	if event.is_action_pressed("action") and $DetectObjectOverPathBox.get_overlapping_areas().size() <= 0:
#		if door_open:
#			$AnimatedSprite.play("close")
#			$MovementCollision/CollisionShape2D.disabled = false
#		else:
#			$AnimatedSprite.play("open")
#			$MovementCollision/CollisionShape2D.disabled = true
#		door_open = !door_open
