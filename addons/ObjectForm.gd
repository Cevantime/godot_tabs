@tool
extends GridContainer

@onready var file_line_edit = $FileLineEdit
@onready var control = $Control
@onready var error_file = $ErrorFile
@onready var name_line_edit = $NameLineEdit
@onready var image_line_edit = $ImageLineEdit
@onready var control_2 = $Control2
@onready var error_image = $ErrorImage

signal closed()
signal validated(validated_data: Dictionary)

func _on_close_button_pressed():
	hide_errors()
	emit_signal("closed")

func hide_errors():
	for e in get_tree().get_nodes_in_group("godot_tabs_error"):
		e.hide()
		
func get_image_from_path(img_path):
	if img_path and img_path != "":
		var img = Image.load_from_file(img_path)
		if img == null:
			return null
		return ImageTexture.create_from_image(img)
	else :
		return null
	
	return true
	
func _on_validate_object_button_pressed():
	var uid = ResourceLoader.get_resource_uid(file_line_edit.text)
	var error = false
	
	if uid == -1:
		error_file.text = "Resource not found"
		error_file.show()
		control.show()
		error = true
		
	var scene_path = file_line_edit.text
	var packed_scene = load(scene_path)
	
	if not (packed_scene is PackedScene):
		error_file.text = "Resource path is not a scene"
		error_file.show()
		control.show()
		error = true
		
	var image = image_line_edit.text
	var texture = get_image_from_path(image)
	if image != "" and texture == null :
		error_image.text = "Invalid image path"
		error_image.show()
		control_2.show()
		error = true
	
	if error :
		return
	
	hide_errors()
		
	emit_signal("validated", {
		"name" : name_line_edit.text,
		"image_path" : image,
		"texture" : texture,
		"scene_path": scene_path,
		"packed_scene" : packed_scene,
		"uid" : uid
	})

