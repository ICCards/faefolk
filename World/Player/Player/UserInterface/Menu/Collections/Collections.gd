extends Control

var page = "CropCollection"
var item = null
var tab = null
var adjusted_pos = Vector2.ZERO

func _ready():
	initialize()

func _physics_process(delta):
	if item:
		if page == "Crops" and CollectionsData.crops[item] != 0:
			set_adjusted_pos()
			$ItemNameBox.hide()
			$CollectionItemDescription.initialize(item)
			$CollectionItemDescription.position = adjusted_pos
		elif page == "Fish" and CollectionsData.fish[item] != 0:
			$ItemNameBox.hide()
			$CollectionItemDescription.initialize(item)
			$CollectionItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		else:
			$CollectionItemDescription.hide()
			$ItemNameBox.item_name = "?????"
			$ItemNameBox.initialize()
			$ItemNameBox.position = get_local_mouse_position() + Vector2(20 , 25)
	elif tab:
		$ItemNameBox.item_name = tab
		$ItemNameBox.initialize()
		$ItemNameBox.position = get_local_mouse_position() + Vector2(20 , 25)
	else:
		$CollectionItemDescription.hide()
		$ItemNameBox.hide()

func set_adjusted_pos():
	yield(get_tree(), "idle_frame")
	var height = $CollectionItemDescription/GridContainer.rect_size.y
	adjusted_pos = get_local_mouse_position() + Vector2(20 , 25)


func initialize():
	show()
	page = "Crops"
	$FishCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")
	$CropCollection.initialize()

func _on_Crops_pressed():
	page = "Crops"
	$FishCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")
	$CropCollection.initialize()
	

func _on_Fish_pressed():
	page = "Fish"
	$CropCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections2.png")
	$FishCollection.initialize()

func _on_Forage_pressed():
	$CropCollection.hide()
	$FishCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections3.png")

func _on_Minerals_pressed():
	$CropCollection.hide()
	$FishCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections4.png")

func _on_Foods_pressed():
	$CropCollection.hide()
	$FishCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections5.png")



func _on_Crops_mouse_entered():
	tab = "Crops"
func _on_Crops_mouse_exited():
	tab = null

func _on_Fish_mouse_entered():
	tab = "Fish"
func _on_Fish_mouse_exited():
	tab = null
	
func _on_Forage_mouse_entered():
	tab = "Forage"
func _on_Forage_mouse_exited():
	tab = null
	
func _on_Minerals_mouse_entered():
	tab = "Minerals"
func _on_Minerals_mouse_exited():
	tab = null
	
func _on_Foods_mouse_entered():
	tab = "Food"
func _on_Foods_mouse_exited():
	tab = null

