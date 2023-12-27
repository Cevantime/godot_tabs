@tool
extends EditorPlugin

var objects_panel
var objects_panel_packed = preload("res://addons/godot_tabs/ObjectsTabs.tscn")

func _enter_tree():
	objects_panel = objects_panel_packed.instantiate()
	if FileAccess.file_exists(TabsPluginUtils.SAVE_FILE):
		var file = FileAccess.open(TabsPluginUtils.SAVE_FILE,FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		objects_panel.initialize(data)
	add_control_to_bottom_panel(objects_panel, "My Tabs")



func _exit_tree():
	remove_control_from_bottom_panel(objects_panel)
	TabsPluginUtils.save_tabs(objects_panel)
