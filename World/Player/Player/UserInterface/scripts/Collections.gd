extends Control

var page = "CropCollection"
var item = null
var tab = null


func _physics_process(delta):
	if item:
		if CollectionsData.crops[item] != 0:
			$ItemNameBox.hide()
			$CollectionItemDescription.initialize(item)
			$CollectionItemDescription.position = get_local_mouse_position() + Vector2(28 , 40)
		else:
			$CollectionItemDescription.hide()
			$ItemNameBox.item_name = "?????"
			$ItemNameBox.initialize()
			$ItemNameBox.position = get_local_mouse_position() + Vector2(28 , 40)
	elif tab:
		$ItemNameBox.item_name = tab
		$ItemNameBox.initialize()
		$ItemNameBox.position = get_local_mouse_position() + Vector2(28 , 40)
	else:
		$CollectionItemDescription.hide()
		$ItemNameBox.hide()



func initialize():
	show()
	page = "CropCollection"
	$CropCollection.show()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")
	$CropCollection.intialize()

func _on_Crops_pressed():
	page = "CropCollection"
	$CropCollection.show()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")
	$CropCollection.intialize()
	

func _on_Fish_pressed():
	$CropCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections2.png")

func _on_Forage_pressed():
	$CropCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections3.png")

func _on_Minerals_pressed():
	$CropCollection.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections4.png")

func _on_Foods_pressed():
	$CropCollection.hide()
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

