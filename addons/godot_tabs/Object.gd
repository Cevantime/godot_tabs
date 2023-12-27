@tool
extends PanelContainer

var image: String
var text: String
var path: String
var ruid
var packed_scene: PackedScene
var node_path: String

@onready var label = $MarginContainer/VBoxContainer/Label
@onready var v_box_container = $MarginContainer/VBoxContainer
@onready var grid_container = $MarginContainer/GridContainer
@onready var file_line_edit = $MarginContainer/GridContainer/FileLineEdit
@onready var name_line_edit = $MarginContainer/GridContainer/NameLineEdit
@onready var image_line_edit = $MarginContainer/GridContainer/ImageLineEdit
@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var error_file = $MarginContainer/GridContainer/ErrorFile
@onready var error_image = $MarginContainer/GridContainer/ErrorImage
@onready var control = $MarginContainer/GridContainer/Control
@onready var control_2 = $MarginContainer/GridContainer/Control2

signal add_requested(object)
signal object_edited(object)

const UUID = preload("res://addons/godot_tabs/UUID.gd")
const THUMBNAIL_PATH = 'res://addons/godot_tabs/thumbnails'

var old_image_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	if !packed_scene:
		if ruid:
			packed_scene = load(ruid)
		elif path:
			packed_scene = load(path)
	set_text(text)
	if packed_scene:
		texture_rect.path = packed_scene.resource_path
		texture_rect.ruid = ruid

func set_text(text = ""):
	if (!text or text == "") and packed_scene:
		var resource_path = packed_scene.resource_path
		var splited = resource_path.split("/")
		splited.reverse()
		var first = splited[0]
		self.text = first.split(".")[0]
	else:
		self.text = text
		
	label.text = self.text
	
func initialize_image():
	if image and image != "":
		var img = Image.load_from_file(image)
		if img == null:
			return false
		texture_rect.texture = ImageTexture.create_from_image(img)
	else :
		generate_preview()
	
	return true
	
func _on_preview_generated(path: String, preview: Texture2D, thumbnail: Texture2D, userdata):
	if preview:
		texture_rect.texture = preview
		var uuid = UUID.new();
		var texture_filename = uuid.as_string()
		var texture_path = THUMBNAIL_PATH + "/" + texture_filename + ".png"
		ResourceSaver.save(preview, texture_path)
		image = texture_path;
		image_line_edit.text = path
	

func generate_preview():
	EditorInterface.get_resource_previewer().queue_edited_resource_preview(packed_scene, self, "_on_preview_generated", {})

func _on_remove_button_pressed():
	remove_if_thumbnail(image)
	queue_free()


func _on_edit_button_pressed():
	packed_scene = load(ruid)
	file_line_edit.text = packed_scene.resource_path
	name_line_edit.text = text
	image_line_edit.text = image
	old_image_path = image
	grid_container.show()
	v_box_container.hide()


func _get_drag_data(at_position):
	packed_scene = load(ruid)
	return { "type": "files", "files": [packed_scene.resource_path], "self_index" : get_index() }

func _on_close_button_pressed():
	grid_container.hide()
	v_box_container.show()

func remove_if_thumbnail(image_path):
	if image_path.rsplit("/", true, 1)[0] == THUMBNAIL_PATH:
		DirAccess.remove_absolute(image_path)
		if FileAccess.file_exists(image_path + ".import"):
			DirAccess.remove_absolute(image_path + ".import")


	
func _on_validate_object_button_pressed(validated_data):
	var image = validated_data.image_path
	
	if ! image:
		generate_preview()
	
	if old_image_path != image :
		remove_if_thumbnail(old_image_path)
		
	ruid = ResourceUID.id_to_text(validated_data.uid)
	set_text(name_line_edit.text)
	grid_container.hide()
	v_box_container.show()
	emit_signal("object_edited", self)


func _on_see_button_pressed():
	var rs = packed_scene.resource_path
	EditorInterface.open_scene_from_path(rs)
	packed_scene.resource_path = rs


func _on_refresh_button_pressed():
	remove_if_thumbnail(image)
	generate_preview()
