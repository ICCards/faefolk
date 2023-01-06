extends Control

onready var sound_effects: AudioStreamPlayer = $SoundEffects

onready var IcKitty = preload("res://World/Player/Pet/PlayerPet.tscn")

var is_kitty_visible: bool = false

func _ready():
	$AnimatedSprite.frames = Images.randomKitty

func set_kitty():
	if is_kitty_visible:
		#$AnimatedSprite.show()
		$SpawnLabel.text = "Despawn"
		spawn_IC_kitty()
	else: 
		#$AnimatedSprite.hide()
		$SpawnLabel.text = "Spawn"
		if Server.world.has_node("Kitty"):
			Server.world.get_node("Kitty").queue_free()


func spawn_IC_kitty():
	$AnimatedSprite.play("idle right")
	var kitty = IcKitty.instance()
	kitty.name = "Kitty"
	kitty.global_position = Server.player_node.position + Vector2(-50,0)
	Server.world.call_deferred("add_child", kitty)

func _on_SpawnPet_pressed():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/smallSelect.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	is_kitty_visible = !is_kitty_visible
	set_kitty()
