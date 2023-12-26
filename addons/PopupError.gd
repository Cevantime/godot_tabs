@tool
extends Window

@onready var label = $VBoxContainer/Label

var text :
	set(v):
		if not is_node_ready():
			await ready
		label.text = v

func _on_button_pressed():
	queue_free()


func _on_close_requested():
	queue_free()
