import bpy
from bpy_extras.io_utils import ExportHelper
from bpy.props import StringProperty, BoolProperty, EnumProperty
from bpy.types import Operator
from string import ascii_lowercase, digits
from random import choice

from wiggle_2 import WigglePanel

ID_CHARS = ascii_lowercase + digits

bl_info = {
    "name": "Wiggle Godot Export",
    "author": "Gonderage/pmdevita",
    "version": (1, 1, 0),
    "blender": (3, 00, 0),
    "location": "3d Viewport > Animation Panel",
    "description": "Export Wigglebone data for use in Godot",
    "warning": "",
    "wiki_url": "https://github.com/shteeve3d/blender-wiggle-2",
    "category": "Animation",
}


def random_string(length):
    return "".join([choice(ID_CHARS) for i in range(length)])


class WIGGLE_PT_Export(WigglePanel, bpy.types.Panel):
    bl_label = "Wiggle 2 Export"

    def draw(self, context):
        layout = self.layout
        scene = context.scene
        row = self.layout.row()
        row.scale_y = 3.0
        row.operator("wiggle.export")


def write_some_data(context, filepath):
    scene = context.scene
    data = {}
    wb_item_id = f"1_{random_string(5)}"
    wb_res_id = f"2_{random_string(5)}"

    file = f"""[gd_resource type="Resource" script_class="WiggleBone" load_steps=4 format=3 uid="uid://{random_string(12)}"]

[ext_resource type="Script" path="res://addons/wigglebones/resources/wiggleboneitem.gd" id="{wb_item_id}"]
[ext_resource type="Script" path="res://addons/wigglebones/resources/wigglebone.gd" id="{wb_res_id}"]
"""

    bones = []
    for wo in scene.wiggle.list:
        ob = scene.objects[wo.name]
        if ob.wiggle_mute or ob.wiggle_freeze:
            continue
        for wb in wo.list:
            b = ob.pose.bones[wb.name]
            if b.wiggle_mute or not (b.wiggle_head or b.wiggle_tail):
                continue
            bones.append(ob.pose.bones[wb.name])

    subresource_ids = []

    bone_data = []
    for bone in bones:
        subresource_id = f"Resource_{random_string(5)}"
        subresource_ids.append(subresource_id)
        bone_data.append(
            f"""[sub_resource type="Resource" id="{subresource_id}"]
script = ExtResource("{wb_item_id}")
bone_name = "{bone.name}"
enable_head = {"true" if bone.wiggle_head and not bone.bone.use_connect else "false"}
head_damp = {bone.wiggle_damp_head}
head_mass = {bone.wiggle_mass_head}
head_stiff = {bone.wiggle_stiff_head}
head_stretch = {bone.wiggle_stretch_head}
head_radius = {bone.wiggle_radius_head}
enable_tail = {"true" if bone.wiggle_tail else "false"}
tail_damp = {bone.wiggle_damp}
tail_mass = {bone.wiggle_mass}
tail_stiff = {bone.wiggle_stiff}
tail_stretch = {bone.wiggle_stretch}
tail_radius = {bone.wiggle_radius}
tail_gravity = {bone.wiggle_gravity}
"""
        )

    file += "".join(bone_data)

    file += f"""[resource]
script = ExtResource("{wb_res_id}")
bones = Array[ExtResource("{wb_item_id}")]([{', '.join([f'SubResource("{id}")' for id in subresource_ids])}])
    """

    with open(filepath, "w", encoding="utf-8") as f:
        f.write(file)

    return {"FINISHED"}


class WiggleExport(Operator, ExportHelper):
    """This appears in the tooltip of the operator and in the generated docs"""

    bl_idname = "wiggle.export"
    bl_label = "Export Wiggle to Godot"

    # ExportHelper mixin class uses this
    filename_ext = ".tres"

    filter_glob: StringProperty(
        default="*.tres",
        options={"HIDDEN"},
        maxlen=255,  # Max internal buffer length, longer would be clamped.
    )

    # # List of operator properties, the attributes will be assigned
    # # to the class instance from the operator settings before calling.
    # use_setting: BoolProperty(
    #     name="Example Boolean",
    #     description="Example Tooltip",
    #     default=True,
    # )
    #
    # type: EnumProperty(
    #     name="Example Enum",
    #     description="Choose between two items",
    #     items=(
    #         ('OPT_A', "First Option", "Description one"),
    #         ('OPT_B', "Second Option", "Description two"),
    #     ),
    #     default='OPT_A',
    # )

    def execute(self, context):
        return write_some_data(context, self.filepath)


def register():
    bpy.utils.register_class(WIGGLE_PT_Export)
    bpy.utils.register_class(WiggleExport)


def unregister():
    bpy.utils.unregister_class(WIGGLE_PT_Export)
    bpy.utils.unregister_class(WiggleExport)


if __name__ == "__main__":
    register()
