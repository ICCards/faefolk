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
onready var plantSeedsTextureRect = $PlantSeedsUI/PlantSeedText
onready var plantSeedsColorRect = $PlantSeedsUI/PlantSeedColor
	
	
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

func _input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
		if event.is_action_pressed("mouse_click") and itemCategory == "Seeds":
			place_seed(item_name)
		
func _unhandled_input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and PlayerInventory.viewInventoryMode == false:
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
		if itemCategory != 'Seeds':
			plantSeedsColorRect.visible = false
			plantSeedsTextureRect.visible = false
		if event.is_action_pressed("mouse_click") and itemCategory == "Weapon":
			state = SWING
			swing_state(event, item_name)
	else:
		plantSeedsColorRect.visible = false
		plantSeedsTextureRect.visible = false
		
onready var PlantCrop = preload("res://InventoryLogic/PlantCrop.tscn")	
onready var world = get_tree().current_scene
var t = Timer.new()

func place_seed(seed_name):
	var mousePos = get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	var location = hoedGrassTilemap.world_to_map(mousePos)
	seed_name.erase(seed_name.length() - 6, 6)
	if plantCropFlag:
		PlayerInventory.add_planted_crop(seed_name, location, false, int(JsonData.crop_data[seed_name]["DaysToGrow"]))
		var plantCrop = PlantCrop.instance()
		plantCrop.init(seed_name, location)
		world.add_child(plantCrop)
		plantCrop.global_position = mousePos
	
func movement_state(delta):
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
	
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
		if itemCategory == "Seeds":
			place_seeds_state(delta, item_name)
		else: 
			plantSeedsColorRect.visible = false
			plantSeedsTextureRect.visible = false

var swingActive = false
func swing_state(_delta, weaponType):
		if !swingActive:
				var toolName = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				swingActive = true
				set_melee_collision_layer(toolName)
				if weaponType == "Hoe":
					set_hoed_tile(get_position(), direction)
				if weaponType == "Bucket":
					set_watered_tile(get_position(), direction)
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

onready var hoedGrassTilemap = get_node("/root/World/YSort/PlayerHome/HoedAutoTiles")
onready var wateredGrassTilemap = get_node("/root/World/YSort/PlayerHome/WateredAutoTiles")
onready var groundTilemap = get_node("/root/World/YSort/PlayerHome/GroundTiles")

func set_hoed_tile(position, direction):
	if direction == "UP":
		position += Vector2(0, -60)
	elif direction == "DOWN":
		position += Vector2(0, 40)
	elif direction == "LEFT":
		position += Vector2(-50, -20)
	elif direction == "RIGHT":
		position += Vector2(50, -20)
	var location = hoedGrassTilemap.world_to_map(position)
	if groundTilemap.get_cellv(location) != -1:
		hoedGrassTilemap.set_cellv(location, 0)
		hoedGrassTilemap.update_bitmask_region()
		
func set_watered_tile(position, direction):
	if direction == "UP":
		position += Vector2(0, -48)
	elif direction == "DOWN":
		position += Vector2(0, 16)
	elif direction == "LEFT":
		position += Vector2(-32, -16)
	elif direction == "RIGHT":
		position += Vector2(32, -16)
	var location = hoedGrassTilemap.world_to_map(position)
	if hoedGrassTilemap.get_cellv(location) != -1:
		wateredGrassTilemap.set_cellv(location, 0)
		wateredGrassTilemap.update_bitmask_region()
		PlayerInventory.add_watered_tile(location)
		
		
		
onready var SeedsScene = preload("res://InventoryLogic/PlaceSeedsObject.tscn")

var isCellFilled
func is_cell_filled(location):
	for i in range(200):
		if PlayerInventory.plantedCrops.has(i):
			if PlayerInventory.plantedCrops[i][1] == location:
				isCellFilled = true
				return
	isCellFilled = false
			
var plantCropFlag
func place_seeds_state(event , seed_name):
	plantSeedsColorRect.visible = true
	plantSeedsTextureRect.visible = true
	seed_name.erase(seed_name.length() - 6, 6)
	plantSeedsTextureRect.texture = load("res://Assets/crop_sets/" + seed_name + "/1.png")
	var mousePos = get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	var location = hoedGrassTilemap.world_to_map(mousePos)
	plantSeedsColorRect.set_global_position(mousePos)
	plantSeedsTextureRect.set_global_position(mousePos - Vector2(0, 32))
	is_cell_filled(location)
	if hoedGrassTilemap.get_cellv(location) != -1 and !isCellFilled:
		plantSeedsColorRect.color = Color(0, 1, 0, 0.5)
		plantCropFlag = true
	else: 
		plantSeedsColorRect.color = Color(1, 0, 0, 0.5)
		plantCropFlag = false

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
	elif toolName == "Bucket":
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


func _on_Button_pressed():
	wateredGrassTilemap.clear()
	get_tree().call_group("crops", "advance_day")

