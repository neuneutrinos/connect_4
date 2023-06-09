@tool
extends MeshInstance3D
class_name Token

var height_velocity:float
var h_end
func _init(_mesh:Mesh,shader_material:Material,column_index:int,h_start:float,_h_end:float):
	self.mesh=_mesh
	self.set_surface_override_material(0,shader_material)
	self.h_end=_h_end
	translate(Vector3(0,h_start,column_index))
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector3(0,height_velocity*delta,0))
	height_velocity+=Global.TOKEN_HEIHT_ACCELERATION*delta
	if transform.origin.y<=h_end:
		transform.origin.y=h_end
		set_process(false)
