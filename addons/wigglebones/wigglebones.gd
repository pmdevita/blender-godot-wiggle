@tool
extends EditorPlugin

const MyButton = preload("res://addons/wigglebones/wigglemenu.tscn")
const WiggleBoneNode = preload("res://addons/wigglebones/wigglebone_node.gd")
var button = MyButton.instantiate()


func _enter_tree():
	add_custom_type("Wigglebone", "Node3D", preload("wigglebone_node.gd"), preload("res://addons/wigglebones/wigglebone.svg"))
	button.editor = self
	get_editor_interface().get_selection().connect("selection_changed", _on_selection_change)
	button.attach()
	
func get_current_wigglebone_node():
	var selection = get_editor_interface().get_selection().get_selected_nodes()
	if selection.size() != 1:
		return null
	var node = selection[0]
	if not node is WiggleBoneNode:
		return null
	return node
	
	
func _on_selection_change():
	var wiggle_node = get_current_wigglebone_node()
	if wiggle_node == null:
		button.detach()
	else:
		button.attach()


func _exit_tree():
	remove_custom_type("Wigglebone")
	get_editor_interface().get_selection().disconnect("selection_changed", _on_selection_change)
	button.detach()
	

func update_bones():
	var wiggle_node = get_current_wigglebone_node()
	if wiggle_node == null:
		return
	var skeleton = wiggle_node.get_parent()
	if not skeleton is Skeleton3D:
		return
	print("all clear!")
	
	var wiggle_bone_names = []
	var wiggle_bone_parents = []
	
	for bone in wiggle_node.bones.bones:
		wiggle_bone_names.append(bone.bone_name)
		var parent_bone = skeleton.get_bone_name(skeleton.get_bone_parent(skeleton.find_bone(bone.bone_name)))
		if not parent_bone in wiggle_bone_parents:
			wiggle_bone_parents.append(parent_bone)
	
	var lambda = func(bone_name): not wiggle_bone_names.has(bone_name)
	
	wiggle_bone_parents = wiggle_bone_parents.filter(func(bone_name): return not bone_name in wiggle_bone_names)
	
	var existing_wiggle = {}
	
	for child in wiggle_node.get_children():
		if not child is PhysicalBone3D:
			continue
		var bone_name = child.bone_name
		if bone_name in wiggle_bone_parents:
			wiggle_bone_parents.erase(bone_name)
		if bone_name in wiggle_bone_names:
			existing_wiggle[bone_name] = child
	
	for bone_name in wiggle_bone_parents:
		var bone_node = generate_phy_bone(wiggle_node, bone_name)
		configure_parent_bone(bone_node, bone_name)
	
	for bone in wiggle_node.bones.bones:
		var bone_name = bone.bone_name
		var bone_node
		if bone_name in existing_wiggle:
			bone_node = existing_wiggle[bone_name]
		else:
			bone_node = generate_phy_bone(wiggle_node, bone_name)
		configure_wiggle_bone(bone, bone_node)
		
		
		
func generate_phy_bone(wiggle_node, bone_name):
	var scene_root = get_editor_interface().get_edited_scene_root()
	var bone_node = PhysicalBone3D.new()
	var collision_node = CollisionShape3D.new()
	wiggle_node.add_child(bone_node)
	bone_node.owner = scene_root
	bone_node.add_child(collision_node)
	collision_node.owner = scene_root
	return bone_node
	

func configure_parent_bone(bone_node, bone_name):
	var collision_node = bone_node.get_child(0)
	bone_node.name = bone_name + "_parent"
	collision_node.name = bone_name + "_col"
	bone_node.bone_name = bone_name
	var shape = SphereShape3D.new()
	shape.radius = 0.001
	collision_node.shape = shape
	
	
func configure_wiggle_bone(bone, bone_node):
	var bone_name = bone.bone_name
	var collision_node = bone_node.get_child(0)
	bone_node.name = bone_name + "_wb"
	collision_node.name = bone_name + "_col"
	bone_node.bone_name = bone_name
	var shape = SphereShape3D.new()
	shape.radius = max(0.001, bone.tail_radius)
	collision_node.shape = shape
	bone_node.joint_type = 5  # JOINT_TYPE_6DOF
	bone_node.mass = bone.tail_mass
	for d in ["x", "y", "z"]:
		bone_node.set("joint_constraints/%s/linear_limit_enabled" % d, true)
		bone_node.set("joint_constraints/%s/linear_limit_upper" % d, 0)
		bone_node.set("joint_constraints/%s/linear_limit_lower" % d, 0)
		bone_node.set("joint_constraints/%s/angular_limit_upper" % d, 180)
		bone_node.set("joint_constraints/%s/angular_limit_lower" % d, -180)
		bone_node.set("joint_constraints/%s/angular_damping" % d, bone.tail_damp)
		bone_node.set("joint_constraints/%s/angular_spring_enabled" % d, true)
		bone_node.set("joint_constraints/%s/angular_spring_stiffness" % d, bone.tail_stiff)
		
		
	
	
