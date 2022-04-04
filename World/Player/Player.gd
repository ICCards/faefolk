extends KinematicBody2D

export(int) var speed = 260.0

onready var bodySprite = $CompositeSprites/Body
onready var armsSprite = $CompositeSprites/Arms
onready var accessorySprite = $CompositeSprites/Accessory
onready var headAttributeSprite = $CompositeSprites/HeadAtr
onready var pantsSprite = $CompositeSprites/Pants
onready var shirtsSprite = $CompositeSprites/Shirts
onready var shoesSprite = $CompositeSprites/Shoes
onready var toolEquippedSprite = $CompositeSprites/ToolEquipped
onready var animation_player = $CompositeSprites/AnimationPlayer
	
	
onready var state = MOVEMENT
enum {
	MOVEMENT, 
	SWING
}

onready var direction = "DOWN"

func _process(delta) -> void:
	if PlayerInventory.viewInventoryMode == false:
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
		match state:
			MOVEMENT:
				movement_state(delta)
	else: 
		idle_state(direction)


func _unhandled_input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and PlayerInventory.viewInventoryMode == false:
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
		if event.is_action_pressed("mouse_click") and itemCategory == "Weapon":
			state = SWING
			swing_state(event, item_name)
		elif event.is_action_pressed("mouse_click") and itemCategory == "Seeds":
			place_seeds_state(event, item_name)
				
				
func movement_state(_delta):
	animation_player.play("movement")
	var velocity = Vector2.ZERO			
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0
		direction = "UP"
		walk_state(direction)
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0
		direction = "DOWN"
		walk_state(direction)
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0
		direction = "LEFT"
		walk_state(direction)
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0
		direction = "RIGHT"
		walk_state(direction)		
	if Input.is_action_pressed("ui_right") == false && Input.is_action_pressed("ui_left") == false && Input.is_action_pressed("ui_up") == false && Input.is_action_pressed("ui_down") == false:
		idle_state(direction)
			
	velocity = velocity.normalized()
	move_and_slide(velocity * speed)	


var swingActive = false
func swing_state(_delta, weaponType):
		if !swingActive:
				var toolName = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				swingActive = true
				set_melee_collision_layer(toolName)
				if weaponType == "Hoe":
					set_hoed_grass_tile(get_position(), direction)
				toolEquippedSprite.set_texture(Global.returnToolSprite(toolName, direction.to_lower()))
				setPlayerTexture("swing_" + direction.to_lower())
				animation_player.play("swing_" + direction.to_lower())
				yield(animation_player, "animation_finished" )
				toolEquippedSprite.texture = null
				state = MOVEMENT
				swingActive = false
		elif swingActive == true:
			pass
		else:
			state = MOVEMENT

onready var hoedGrassTilemap = get_node("/root/World/YSort/PlayerHome/HoeAutoTile")
onready var groundTilemap = get_node("/root/World/YSort/PlayerHome/GroundTiles")

func set_hoed_grass_tile(position, direction):
	if direction == "UP":
		position += Vector2(0, -60)
	elif direction == "DOWN":
		position += Vector2(0, 40)
	elif direction == "LEFT":
		position += Vector2(-50, -20)
	elif direction == "RIGHT":
		position += Vector2(50, -20)
	var pos = hoedGrassTilemap.world_to_map(position)
	if groundTilemap.get_cellv(pos) != -1:
		hoedGrassTilemap.set_cellv(pos, 0)
		hoedGrassTilemap.update_bitmask_region()

onready var SeedsScene = preload("res://InventoryLogic/PlaceSeedsObject.tscn")
onready var world = get_tree().current_scene

func place_seeds_state(event , seed_name):
	pass
#	var pos = hoedGrassTilemap.world_to_map(event.position)
#	print(event.global_position)
#	print('-------')
#	if groundTilemap.get_cellv(pos) != -1:
#		print('display')
#		var seedsScene = SeedsScene.instance()
#		seedsScene.init(seed_name)
#		world.add_child(seedsScene)
#		seedsScene.global_position = event.global_position

func idle_state(direction):
	setPlayerTexture("idle_" + direction.to_lower())

func walk_state(direction):
	setPlayerTexture("walk_" + direction.to_lower())

func set_melee_collision_layer(toolName):
	if toolName == "Axe": 
		$MeleeSwing.set_collision_mask(8)
	elif toolName == "Pickaxe":
		$MeleeSwing.set_collision_mask(16)
	elif toolName == "Hoe":
		$MeleeSwing.set_collision_mask(0)
	elif toolName == "Sword":
		$MeleeSwing.set_collision_mask(0)
		
func setPlayerTexture(var anim):
	bodySprite.set_texture(Global.body_sprites[anim])
	armsSprite.set_texture(Global.arms_sprites[anim])
	accessorySprite.set_texture(Global.acc_sprites[anim])
	headAttributeSprite.set_texture(Global.headAtr_sprites[anim])
	pantsSprite.set_texture(Global.pants_sprites[anim])
	shirtsSprite.set_texture(Global.shirts_sprites[anim])
	shoesSprite.set_texture(Global.shoes_sprites[anim])



