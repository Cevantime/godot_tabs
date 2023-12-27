extends Node
class_name TabsPluginUtils

const SAVE_FILE = "res://addons/godot_tabs/data.json"
const error_window_packed = preload("res://addons/godot_tabs/PopupError.tscn")

static var node_paths = []

static func append_before(node_to_append, ref_node):
	var parent = ref_node.get_parent()
	parent.add_child(node_to_append)
	parent.move_child(node_to_append, ref_node.get_index())

static func display_error(error):
	var error_window = error_window_packed.instantiate()
	error_window.text = error
	EditorInterface.popup_dialog_centered(error_window)

static func save_tabs(tabs: TabContainer):
	if not tabs.is_node_ready():
		return
	var data = {}
	for i in range(tabs.get_tab_count() - 1):
		var tab = tabs.get_tab_control(i)
		var tab_data = {}
		data[tab.name] = tab_data
		var objects = []
		tab_data["objects"] = objects
		tab_data["index"] = i
		for j in range(tab.h_flow_container.get_child_count() - 1):
			var object = tab.h_flow_container.get_child(j)
			if "text" in object:
				var object_data = {}
				object_data["ruid"] = object.ruid
				object_data["text"] = object.text
				object_data["path"] = object.packed_scene.resource_path if object.packed_scene else object.path
				object_data["image"] = object.image
				objects.push_back(object_data)
		
	
	var file_access = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file_access:
		file_access.store_string(JSON.stringify(data))
		file_access.flush()

	
