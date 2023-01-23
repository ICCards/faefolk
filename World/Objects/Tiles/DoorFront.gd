extends Area2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var door_open = false

var id
var location
var tier
var health
var max_health
var temp_health = 0
var entered = false

var object_name = "door"

func _ready():
	set_type()


func toggle_door():
		if door_open:
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorOpen.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
			sound_effects.play()
			#$AnimationPlayer.play("close")
			$AnimatedSprite.play("close")
			$DoorMovementCollision/CollisionShape2D.disabled = false
		else:
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorClose.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
			sound_effects.play()
			#$AnimationPlayer.play("open")
			$AnimatedSprite.play("open")
			$DoorMovementCollision/CollisionShape2D.disabled = true
		door_open = !door_open
	
func set_type():
	match tier:
		"wood":
			$AnimatedSprite.frames = load("res://Assets/Tilesets/doors/animated/front/wood.tres")
			health = Stats.MAX_WOOD_DOOR
			max_health = Stats.MAX_WOOD_DOOR
		"metal":
			$AnimatedSprite.frames = load("res://Assets/Tilesets/doors/animated/front/metal.tres")
			health = Stats.MAX_METAL_DOOR
			max_health = Stats.MAX_METAL_DOOR
		"armored":
			$AnimatedSprite.frames = load("res://Assets/Tilesets/doors/animated/front/armored.tres")
			health = Stats.MAX_ARMORED_DOOR
			max_health = Stats.MAX_ARMORED_DOOR
		"demolish":
			Tiles.add_valid_tiles(location, Vector2(2,1))
			queue_free()
	update_health_bar()



func _on_HurtBox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if door_open:
		$HitEffect/Sprite.texture = load("res://Assets/Tilesets/doors/hit effects/" + tier + "/front/open.png")
		$HitEffect/Sprite.position = Vector2(32,-53)
	else:
		$HitEffect/Sprite.texture = load("res://Assets/Tilesets/doors/hit effects/" + tier + "/front/closed.png")
		$HitEffect/Sprite.position = Vector2(32,-46)
	$HitEffect/AnimationPlayer.stop()
	$HitEffect/AnimationPlayer.play("hit")
	show_health()
	if tier == "twig" or tier == "wood":
		health -= 1
	else:
		temp_health += 1
		if temp_health == 3:
			temp_health = 0
			health -= 1
	if health != 0:
		play_hit_sound_effect()
	update_health_bar()

func update_health_bar():
	if health != 0:
		$HealthBar/Progress.value = health
		$HealthBar/Progress.max_value = max_health
	else:
		remove_tile()

func remove_tile():
	MapData.remove_placable(id)
	Tiles.add_valid_tiles(location, Vector2(2,1))
	play_break_sound_effect()
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()

func show_health():
	$AnimationPlayer2.stop()
	$AnimationPlayer2.play("show health bar")

func _on_HammerRepairBox_area_entered(area):
	play_hammer_hit_sound()
	set_type()
	InstancedScenes.play_upgrade_building_effect(location)
	InstancedScenes.play_upgrade_building_effect(location+ Vector2(1,0))
	show_health()


func play_hit_sound_effect():
	match tier:
		"wood":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/wood/wood hit.mp3")
		"metal":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/metal/metal hit.mp3")
		"armored":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/metal/metal hit.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()


func play_hammer_hit_sound():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/crafting.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()

func play_break_sound_effect():
	match tier:
		"wood":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/wood/wood break.mp3")
		"metal":
			sound_effects.stream = null
		"armored":
			sound_effects.stream = null
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()
