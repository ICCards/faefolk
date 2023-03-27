extends Node2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var entered = false
var door_open = false
var id
var location

var horizontal: bool

var object_name = "gate"
var temp_health = 3

func _ready():
	if horizontal:
		$GatePos/Gate.animation == "wood front" 


func _on_HurtBox_area_entered(area):
	if area.name == "AxePickaxeSwing":
			Stats.decrease_tool_health()
	if temp_health == 0:
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		MapData.remove_placable(name)
		InstancedScenes.intitiateItemDrop("wood gate", position, 1)
		Tiles.add_valid_tiles(location, Vector2(2,1))
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break wood.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound",0))
		sound_effects.call_deferred("play")
		await sound_effects.finished
		queue_free()
	else:
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/Building/wood/wood hit.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound",0))
		sound_effects.call_deferred("play")
		$ResetTempHealthTimer.start()
		temp_health -= 1
		$AnimationPlayer.play("shake")

func toggle_gate():
	if door_open:
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/gate/open.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound",0))
		sound_effects.call_deferred("play")
		$GatePos/Gate.set_deferred("frame", 0)
		$MovementCollision/CollisionShape2D.set_deferred("disabled", false)
	else:
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/gate/close.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound",0))
		sound_effects.call_deferred("play")
		$GatePos/Gate.set_deferred("frame", 1)
		$MovementCollision/CollisionShape2D.set_deferred("disabled", true)
	door_open = !door_open


func _on_ResetTempHealthTimer_timeout():
	temp_health = 3
