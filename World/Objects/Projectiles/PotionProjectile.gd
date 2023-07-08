extends CharacterBody2D

@onready var Mob = load("res://World/Enemies/mob.tscn")
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var _uuid = load("res://helpers/UUID.gd")

var rng = RandomNumberGenerator.new()

var speed = 500
var destroyed: bool = false
var target
var particles_transform
var potion_name

func _physics_process(delta):
	position = position.move_toward(target, delta * speed)
	if position == target:
		if not destroyed:
			destroy()
		return

func _ready():
	rng.randomize()
	if potion_name == "raw egg":
		$Sprite2D.texture = load("res://Assets/Images/Forage/animal/raw egg.png")
	else:
		$Sprite2D.texture = load("res://Assets/Images/inventory_icons/Potion/"+ potion_name  +".png")
		$PotionHitbox.tool_name = potion_name
	if potion_name == "destruction potion I" or potion_name == "destruction potion II" or potion_name == "destruction potion III":
		$PotionHitbox.set_collision_mask(264320)
		$DestructionTrailParticles.show()
		$DestructionTrailParticles.transform = particles_transform
		$DestructionTrailParticles.position += Vector2(0,32)
	elif potion_name == "poison potion I" or potion_name == "poison potion II" or potion_name == "poison potion III":
		$PotionHitbox.set_collision_mask(384)
		$PoisonTrailParticles.show()
		$PoisonTrailParticles.transform = particles_transform
		$PoisonTrailParticles.position += Vector2(0,32)
	elif potion_name == "speed potion I" or potion_name == "speed potion II" or potion_name == "speed potion III":
		$SpeedTrailParticles.show()
		$SpeedTrailParticles.transform = particles_transform
		$SpeedTrailParticles.position += Vector2(0,32)
	else:
		$HealthTrailParticles.show()
		$HealthTrailParticles.transform = particles_transform
		$HealthTrailParticles.position += Vector2(0,32)
	await get_tree().create_timer(0.025).timeout
	if not destroyed:
		$Sprite2D.show()

func destroy():
	destroyed = true
	$Sprite2D.call_deferred("hide")
	if potion_name == "raw egg":
		$AnimationPlayer.call_deferred("play", "raw egg break")
	elif potion_name == "destruction potion I" or potion_name == "destruction potion II" or potion_name == "destruction potion III":
		$AnimationPlayer.call_deferred("play", "destruction potion")
	elif potion_name == "poison potion I" or potion_name == "poison potion II" or potion_name == "poison potion III":
		$AnimationPlayer.call_deferred("play", "poison potion")
	elif potion_name == "speed potion I" or potion_name == "speed potion II" or potion_name == "speed potion III":
		$AnimationPlayer.call_deferred("play", "speed potion")
	else:
		$AnimationPlayer.call_deferred("play", "health potion")
	await $AnimationPlayer.animation_finished
	queue_free()
	


func play_glass_break_sound():
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/Magic/Potion/glass break.mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -14))
	sound_effects.call_deferred("play")
	

func play_egg_break_sound():
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/Animals/duck/egg break.mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -8))
	sound_effects.call_deferred("play")
	spawn_duck()
	
	
func spawn_duck():
	if Tiles.valid_tiles.get_cell_atlas_coords(0,global_position/32) != Vector2i(-1,-1) and Server.world.name == "Overworld":
		if Util.chance(25):
			var uuid = _uuid.new()
			var id = uuid.v4()
			var variety = rng.randi_range(1,3)
			var loc = Vector2i(global_position/32,)
			var chunk = Util.return_chunk_from_location(loc)
			MapData.world[chunk]["animal"][id] = {"l":loc,"n":"duck","v":variety,"h":Stats.DUCK_HEALTH}
			var mob = Mob.instantiate()
			mob.id = id
			mob.chunk = chunk
			Server.world.get_node("Enemies").call_deferred("add_child", mob)
