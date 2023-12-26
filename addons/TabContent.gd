@tool
extends MarginContainer

const object_packed = preload("res://addons/godot_tabs/Object.tscn")
const popup_packed = preload("res://addons/godot_tabs/PopupRenameTab.tscn")
const popup_confirm_packed = preload("res://addons/godot_tabs/PopupConfirm.tscn")

const ObjectClass = preload("res://addons/godot_tabs/Object.gd")

signal object_added(object)
signal object_edited(object)

@onready var add_form_button = $VBoxContainer/HBoxContainer/AddFormButton
@onready var h_flow_container = $VBoxContainer/ScrollContainer/HFlowContainer
@onready var new_object_panel_container = $VBoxContainer/ScrollContainer/HFlowContainer/NewObjectPanelContainer
@onready var file_line_edit = $VBoxContainer/ScrollContainer/HFlowContainer/NewObjectPanelContainer/MarginContainer/VBoxContainer/GridContainer/FileLineEdit
@onready var name_line_edit = $VBoxContainer/ScrollContainer/HFlowContainer/NewObjectPanelContainer/MarginContainer/VBoxContainer/GridContainer/NameLineEdit
@onready var image_line_edit = $VBoxContainer/ScrollContainer/HFlowContainer/NewObjectPanelContainer/MarginContainer/VBoxContainer/GridContainer/ImageLineEdit
@onready var scroll_container = $VBoxContainer/ScrollContainer
@onready var control = $VBoxContainer/ScrollContainer/HFlowContainer/NewObjectPanelContainer/MarginContainer/VBoxContainer/GridContainer/Control
@onready var error_file = $VBoxContainer/ScrollContainer/HFlowContainer/NewObjectPanelContainer/MarginContainer/VBoxContainer/GridContainer/ErrorFile
@onready var control_2 = $VBoxContainer/ScrollContainer/HFlowContainer/NewObjectPanelContainer/MarginContainer/VBoxContainer/GridContainer/Control2
@onready var error_image = $VBoxContainer/ScrollContainer/HFlowContainer/NewObjectPanelContainer/MarginContainer/VBoxContainer/GridContainer/ErrorImage

func initialize(data):
	for o in data:
		add_object(o)
	
func _on_add_form_button_pressed():
	show_form()

func add_object(object_data, before = null):
	var object = object_packed.instantiate()
	object.path = object_data.path
	if "ruid" in object_data and object_data.ruid:
		object.ruid = object_data.ruid
	else:
		var uid = ResourceLoader.get_resource_uid(object.path)
		object.ruid = ResourceUID.id_to_text(uid)
		
	if "text" in object_data and object_data.text != "":
		object.text = object_data.text
	if "image" in object_data and object_data.image != "":
		object.image = object_data.image
	
	if not is_node_ready():
		await self.ready
		
	_setup_object(object, before)
	
func _setup_object(object, before: Control = null):
	if ! before:
		before = h_flow_container.get_child(h_flow_container.get_child_count() - 1)
	TabsPluginUtils.append_before(object, before)
		
	object.initialize_image()
	emit_signal("object_added", object)
	
func _on_add_object_button_pressed(validated_data):
	var object = object_packed.instantiate()
	
	object.path = validated_data.scene_path
	object.ruid = ResourceUID.id_to_text(validated_data.uid)
	file_line_edit.text = ""
	if validated_data.name != "":
		object.text = validated_data.name 
		name_line_edit.text = ""
	if validated_data.image_path != "":
		object.image = validated_data.imahe_path
		image_line_edit.text = ""
	
	_setup_object(object)
	
	hide_form()


func _on_close_button_pressed():
	hide_form()

func hide_form():
	new_object_panel_container.hide()
	add_form_button.show()
	
func show_form():
	add_form_button.hide()
	new_object_panel_container.show()
	ensure_is_visible(new_object_panel_container)

func ensure_is_visible(audio):
	var global_rect = get_global_rect();
	var other_rect = audio.get_global_rect();
	var right_margin = scroll_container.get_v_scroll_bar().size.x if scroll_container.get_v_scroll_bar().is_visible() else 0
	var bottom_margin = scroll_container.get_h_scroll_bar().size.y if scroll_container.get_h_scroll_bar().is_visible() else 0

	var diff = Vector2(max(min(other_rect.position.x, global_rect.position.x), other_rect.position.x + other_rect.size.x - global_rect.size.x + right_margin),
			max(min(other_rect.position.y, global_rect.position.y), other_rect.position.y + other_rect.size.y - global_rect.size.y + bottom_margin))

	scroll_container.scroll_horizontal += diff.x - global_rect.position.x
	scroll_container.scroll_vertical += diff.y - global_rect.position.y

func _on_remove_tab_button_pressed():
	var popup_confirm = popup_confirm_packed.instantiate()
	popup_confirm.text = "Are you sure you want to delete this tab ?"
	EditorInterface.popup_dialog_centered(popup_confirm)
	popup_confirm.connect("confirmed", Callable(self, "_on_delete_confirmed"))

func _on_delete_confirmed(popup):
	popup.queue_free()
	queue_free()


func _can_drop_data(at_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("type") and data.type == "files"
	

func _drop_data(at_position, data):
	var closest_child
	if h_flow_container.get_child_count() > 1:
		closest_child = h_flow_container.get_child(0)
		var closest_child_rect = closest_child.get_rect()
		var closest_child_position = closest_child_rect.position
		var closest_child_squared_distance = closest_child_position.distance_squared_to(at_position)
		for i in range(0, h_flow_container.get_child_count()):
			var c: Control = h_flow_container.get_child(i)
			var c_rect = c.get_rect()
			var c_position = c_rect.position
			var c_squared_distance = c_position.distance_squared_to(at_position)
			if c_squared_distance < closest_child_squared_distance:
				closest_child = c
				closest_child_squared_distance = c_squared_distance
	
	
	if data.has("self_index"):
		var index_target = closest_child.get_index()
		if closest_child.get_index() > data.self_index:
			index_target -= 1
		if closest_child.position.x < at_position.x:
			index_target += 1
		index_target = clamp(index_target, 0, h_flow_container.get_child_count() - 1)
		h_flow_container.move_child(h_flow_container.get_child(data.self_index), index_target)
	else:
		if not (closest_child is ObjectClass):
			closest_child = null
		else :
			if closest_child.get_rect().position.x < at_position.x:
				var closest_child_index = closest_child.get_index()
				if closest_child_index == h_flow_container.get_child_count() - 1:
					closest_child = null
				else:
					closest_child = h_flow_container.get_child(closest_child_index + 1)
		for f in data.files:
			var p = load(f)
			if p is PackedScene:
				add_object({"path": f}, closest_child)
	

func _on_rename_button_pressed():
	var popup = popup_packed.instantiate()
	popup.connect("name_set", Callable(self, "_on_popup_name_set"))
	popup.tab_name = self.name
	EditorInterface.popup_dialog_centered(popup)

func _on_popup_name_set(new_name):
	self.name = new_name


func _on_filter_line_edit_text_changed(new_text: String):
	var objects = []
	for c in h_flow_container.get_children():
		if c.is_in_group("godot_tabs_objects"):
			objects.push_back(c)
	if new_text.length() == 0:
		for o in objects:
			o.show()
		return
	for o in objects:
		if o.text.to_lower().match("*"+new_text.to_lower()+"*"):
			o.show()
		else: 
			o.hide()


