@tool
extends Window

signal confirmed(_self)

var text :
	set(v):
		if not is_node_ready():
			await ready
		label.text = v

@onready var label = $VBoxContainer/Label

func _on_close_requested():
	queue_free()


func _on_button_pressed():
	emit_signal("confirmed", self)


func _on_cancel_button_pressed():
	queue_free()
