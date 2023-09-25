@icon("res://addons/wigglebones/wigglebone.svg")
extends Node3D

@export var bones: WiggleBone = null


# Called when the node enters the scene tree for the first time.
func _ready():
	var bone_names = bones.bones.map(func(bone): return bone.bone_name)
	print("simulating", bone_names)
	get_parent().physical_bones_start_simulation(bone_names)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _get_configuration_warnings():
	if not get_parent() is Skeleton3D:
		return ["Parent is not a Skeleton3D node!"]
	return []
