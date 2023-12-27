@tool
extends LineEdit

func _can_drop_data(at_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("type") and data.type == "nodes"
	

func _drop_data(at_position, data):
	var node_path = data.nodes[0]
	var node: Node = get_node(node_path)
	var owner = node.owner
	if owner:
		text = owner.get_path_to(node)

