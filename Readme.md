# Blender Wigglebones for Godot

Highly WIP support for exporting data from [this plugin](https://github.com/shteeve3d/blender-wiggle-2) and using it in Blender.

With extra thanks to the [Godot Jigglebones](https://github.com/TokisanGames/godot-jigglebones) plugin.

Requires [Godot Jolt](https://github.com/godot-jolt/godot-jolt) physics. Does not work with Godot Physics 
due to [6DOF not being implemented](https://github.com/godotengine/godot/issues/54761).

## Installation

1. Install Godot Jolt
2. Copy the `addons` folder into your project
3. Add the `wiggle_export.py` as a plugin to Blender


## Usage

1. Mark and configure wiggle bones in Blender
2. Export model glb and wiggle bone config resource (there should be a button under the wiggle bone menu).
3. Import model into Godot.
4. Attach a Wigglebone node to the model's Skeleton3D and attach the wiggle bone config resource to it.
5. In the 3D view, click "Generate WiggleBone Collision".
6. There should now be PhysicalBone3D children to your Wigglebone node. Run the project and the simulation should work!



