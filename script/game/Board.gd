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
var token_material_list:Array[ShaderMaterial]

func _ready():
	init_token_materials()
	rebuild()


func init_board_value():
	board_value.clear()
	for c in range(nb_column):
		var line = []
		line.resize(nb_line)
		line.fill(TOKEN_VALUE.EMPTY)
		board_value.append(line)

func init_token_materials():
	const SHADER_PARAM_NAME="playerColorIndex"
	var m1:ShaderMaterial = token_material
	var m2:ShaderMaterial = m1.duplicate()
	var player_color_index_m1:float =m1.get_shader_parameter(SHADER_PARAM_NAME)
	#1^3 == 2 , 2^3 == 1
	var player_color_index_m2:float =(int)(player_color_index_m1)^3
	m2.set_shader_parameter(SHADER_PARAM_NAME,player_color_index_m2)
	print("materials value",[m1.get_shader_parameter(SHADER_PARAM_NAME),m2.get_shader_parameter(SHADER_PARAM_NAME)])
	self.token_material_list=[m1,m2]
	
	
func rebuild()->void:
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
	if(col_index>=nb_column):return nb_line
	var col = board_value[col_index]
	var l_index=0
	while l_index<nb_line && col[l_index] != TOKEN_VALUE.EMPTY :l_index+=1
	return l_index

func spawn_token(col_index:int,player_index:int)->bool:
	var h_index = get_height_index(col_index)
	if h_index == nb_line:return false
	var token = Token.new(token_mesh,token_material_list[player_index],col_index,nb_line,h_index)
	add_child(token)
	board_value[col_index][h_index]=TOKEN_VALUE.PLAYER1+player_index
	return true

#internal "event"
func on_export_change():
	rebuild()
	pass

##DBG##################################


func _on_test_spawn_pressed():
	var col=randi()%nb_column
	var player=1+randi()%2
	var ret=spawn_token(col,player-1)
	print("[DBG]test spawn",{"column":col,"player":player,"return":ret})
pass # Replace with function body.
