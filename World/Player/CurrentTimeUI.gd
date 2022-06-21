extends Node2D



func _ready():
	set_labels()
	PlayerInventory.connect("update_time", self, "set_labels")

func set_labels():
	$SeasonLabel.text = PlayerInventory.season + ", " + str(PlayerInventory.day_num)
