@tool
extends Node3D

@export var wiggle_json: String
@export var bones: WiggleBone = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees.x += 180 + delta
