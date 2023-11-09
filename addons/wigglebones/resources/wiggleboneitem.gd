extends Resource
class_name WiggleBoneItem

@export var bone_name: String = ""
@export var enable_head: bool = false
@export var head_damp: float = 1.0
@export var head_mass: float = 1.0
@export var head_stiff: float = 400.0
@export var head_stretch: float = 0.0
@export var head_radius: float = 0.0


@export var enable_tail: bool = false
@export var tail_damp: float = 1.0
@export var tail_mass: float = 1.0
@export var tail_stiff: float = 400.0
@export var tail_stretch: float = 0.0
@export var tail_radius: float = 0.0
@export var tail_gravity: float = 1.0


func _init(bone_name: String = "", has_head = false, head_damp = 1.0, head_mass = 1.0, head_stiff = 1.0, head_stretch = 400.0, head_radius = 0.0, has_tail = false, tail_damp = 1.0, tail_mass = 1.0, tail_stiff = 1.0, tail_stretch = 400.0, tail_radius = 0.0, tail_gravity = 1.0):
	pass
