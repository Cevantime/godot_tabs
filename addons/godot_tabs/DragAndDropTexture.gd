@tool
extends TextureRect

var path
var ruid

@export var object_path: NodePath

@onready var object = get_node(object_path)

func _get_drag_data(at_position):
	var packed_scene = load(ruid)
	return { "type": "files", "files": [packed_scene.resource_path], "self_index": object.get_index()}
