extends CanvasLayer


var holding_item = null

func _ready():
	initialize_user_interface()

func initialize_user_interface():
	$HotbarNftScene.visible = true

func _input(event):
	if event.is_action_pressed("open_menu") and holding_item == null:
		toggle_inventory()

func toggle_inventory():
	$InventoryNftScene.initialize_inventory()
	$HotbarNftScene.initialize_hotbar()
	PlayerInventoryNftScene.viewInventoryMode = !PlayerInventoryNftScene.viewInventoryMode
	$InventoryNftScene.visible = !$InventoryNftScene.visible

