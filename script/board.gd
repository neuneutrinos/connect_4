@tool
extends Node3D

@export_range(4,50) var size_X : int:
	set(value):
		size_X=value
		size.x=value
		on_size_changed()
		
@export_range(4,50) var size_Y : int:
	set(value):
		size_Y=value
		size.y=value
		on_size_changed()
		
@export var case_mesh :Mesh = preload("res://resource/mesh/board/P4_Box.obj")
@export var case_material:Material = preload("res://resource/material/board_material.tres")

var size:Vector2i


func rebuild()->void:
	for c in get_children():remove_child(c)
	
	for i in range(size.x):
		for j in range(size.y):
			var child:MeshInstance3D = MeshInstance3D.new()
			child.mesh=case_mesh
			child.set_surface_override_material(0,case_material)
			child.translate(Vector3(0,j,i))
			add_child(child)
pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_size_changed():
	print("on_size_changed")
	rebuild()
	pass
