@tool
extends MeshInstance3D
class_name Token


func _init(mesh:Mesh,shader_material:ShaderMaterial,h_start:float,h_end:float):
	self.mesh=mesh
	self.set_surface_override_material(0,shader_material)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
