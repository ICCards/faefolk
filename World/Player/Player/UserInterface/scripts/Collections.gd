extends Control

var page = "CropCollection"
var item = null


func _physics_process(delta):
	if item:
		$CollectionItemDescription.initialize(item)
		$CollectionItemDescription.position = get_local_mouse_position() + Vector2(28 , 40)
	else:
		$CollectionItemDescription.hide()



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



