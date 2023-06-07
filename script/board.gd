@tool
extends Node3D
class_name Board

enum TOKEN_VALUE {EMPTY,PLAYER1,PLAYER2}

@export_group("Board data")
@export_range(4,50) var nb_column : int:
	set(value):
		nb_column=value
		on_export_change()
		
@export_range(4,50) var nb_line : int:
	set(value):
		nb_line=value
		on_export_change()

@export var case_mesh :Mesh = preload("res://resource/mesh/board/P4_Box.obj"):
	set(value):
		case_mesh=value
		on_export_change()
		
@export var case_material:Material = preload("res://resource/material/board_material.tres"):
	set(value):
		case_material=value
		on_export_change()

@export_group("Token data")
@export var token_mesh :Mesh = preload("res://resource/mesh/board/P4_Token.obj")
@export var token_material:ShaderMaterial = preload("res://resource/material/token_shader_material.tres")

var board_value:Array=[]

func init_board_value():
	board_value.clear()
	for c in range(nb_column):
		var line = []
		line.resize(nb_line)
		line.fill(TOKEN_VALUE.EMPTY)
		board_value.append(line)

		
func rebuild()->void:
	print("rebuilding ",[nb_column,nb_line])
	init_board_value()
	for c in get_children():remove_child(c)#clear all children
	for i in range(nb_column):
		for j in range(nb_line):
			var child:MeshInstance3D = MeshInstance3D.new()
			child.mesh=case_mesh
			child.set_surface_override_material(0,case_material)
			child.translate(Vector3(0,j,i))
			add_child(child)
	

#if nb_column is returned => coluln is full or invalid
func get_height_index(col_index:int)->int:
	if(col_index>=nb_column):return nb_column
	var col = board_value[col_index]
	var l_index=0
	while l_index<nb_line && col[l_index] != TOKEN_VALUE.EMPTY :l_index+=1
	return l_index

func spawn_token(col_index:int)->bool:
	var h_index = get_height_index(col_index)
	if h_index == nb_column:return false
	#TODO spawn token
	return true
	pass

#internal "event"
func on_export_change():
	rebuild()
	pass
