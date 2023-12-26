@tool
extends Window

@onready var line_edit = $VBoxContainer/LineEdit

signal name_set(new_name)

var tab_name :
	set(v):
		await ready
		line_edit.text = v 

func _on_validate_button_pressed():
	queue_free()
	emit_signal("name_set", line_edit.text)


func _on_close_requested():
	queue_free()
