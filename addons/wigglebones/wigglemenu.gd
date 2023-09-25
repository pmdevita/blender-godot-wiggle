@tool
extends Button

const WiggleEditor = preload("res://addons/wigglebones/wigglebones.gd")

var is_added = false
var editor: WiggleEditor = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func attach():
	if is_added:
		return
	is_added = true
	editor.add_control_to_container(editor.CONTAINER_SPATIAL_EDITOR_MENU, self)
	
	
func detach():
	if not is_added:
		return
	is_added = false
	editor.remove_control_from_container(editor.CONTAINER_SPATIAL_EDITOR_MENU, self)


func _on_pressed():
	editor.update_bones()
