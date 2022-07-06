extends Control

var action
func initalize(dialogue, _action):
	action = _action
	$Dialogue.text = dialogue


func _on_CancelButton_pressed():
	visible = false
	PlayerInventory.interactive_screen_mode = false


func _on_ConfirmButton_pressed():
	action
	visible = false
	PlayerInventory.interactive_screen_mode = false
