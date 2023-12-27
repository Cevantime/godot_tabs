@tool
extends TabContainer

signal add_requested(object)

const scroll_container_packed = preload("res://addons/godot_tabs/TabContent.tscn")

@onready var line_edit_new_tab = $"+/LineEdit"
@onready var error_label = $"+/ErrorLabel"
@onready var add_tab_tab = $"+"
@onready var last_tab_selected = current_tab

var initializing = false

func _ready():
	var objects = get_tree().get_nodes_in_group("godot_tabs_objects")
	for object in objects:
		if not object.is_connected("object_edited", Callable(self, "_on_object_edited")):
			object.connect("object_edited", Callable(self, "_on_object_edited"))
			

func _on_object_edited(object):
	TabsPluginUtils.save_tabs(self)

func initialize(data: Dictionary):
	initializing = true
	var keys = data.keys()
	keys.sort_custom(func(t1, t2) :
		return data[t1].index < data[t2].index
		)
	for k in keys:
		var new_tab = add_tab(k)
		new_tab.initialize(data[k].objects)
		
	current_tab = 0
	initializing = false

func _on_add_button_pressed():
	error_label.text = ""
	if line_edit_new_tab.text == "":
		error_label.text = "Tab should not be empty"
		return
	for child in get_children():
		if child.name == line_edit_new_tab.text:
			error_label.text = "This name already exists"
			return
	add_tab(line_edit_new_tab.text)
	TabsPluginUtils.save_tabs(self)
	current_tab = get_child_count() - 2
	line_edit_new_tab.text = ""
	
func add_tab(name):
	var new_tab = scroll_container_packed.instantiate()
	new_tab.name = name
	var plus_tab = get_child(get_child_count() - 1)
	TabsPluginUtils.append_before(new_tab, plus_tab)
	new_tab.connect("object_added", Callable(self, "_on_object_added"))
	return new_tab
	
func _on_object_added(object):
	if not initializing:
		TabsPluginUtils.save_tabs(self)
	object.connect("add_requested", Callable(self, "request_add"))


func _on_active_tab_rearranged(idx_to):
	var add_tab_tab_index = get_child_count() - 1
	if last_tab_selected == add_tab_tab_index:
		call_deferred("move_child", add_tab_tab, add_tab_tab_index)
		return
	TabsPluginUtils.save_tabs(self)


func _on_tab_selected(tab):
	last_tab_selected = tab
