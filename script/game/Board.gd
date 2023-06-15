@tool
extends Node3D
class_name Board

enum TOKEN_VALUE {EMPTY,PLAYER1,PLAYER2}

@export_group("Board data")
@export_range(4,50) var nb_column : int=7:
	set(value):
		nb_column=value
		on_export_change()
		
@export_range(4,50) var nb_line : int=6:
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

var ruler:BasicRuler

var board_value:Array=[]
var column_height_index_array:Array[int]

var token_material_list:Array[ShaderMaterial]

func _ready():
	init_token_materials()
	rebuild()
	init_ruler(BasicRuler.new())

func init_ruler(_ruler:BasicRuler):
	self.ruler=_ruler
	ruler.board_ref=self
	ruler.name="GameRuler"
	ruler.on_ready()
	
func init_board_value()->void:
	board_value.clear()
	for c in range(nb_column):
		var line = []
		line.resize(nb_line)
		line.fill(TOKEN_VALUE.EMPTY)
		board_value.append(line)

func init_token_materials()->void:
	const SHADER_PARAM_NAME="playerColorIndex"
	var m1:ShaderMaterial = token_material
	var m2:ShaderMaterial = m1.duplicate()
	var player_color_index_m1:float =m1.get_shader_parameter(SHADER_PARAM_NAME)
	#1^3 == 2 , 2^3 == 1
	var player_color_index_m2:float =(int)(player_color_index_m1)^3
	m2.set_shader_parameter(SHADER_PARAM_NAME,player_color_index_m2)
	self.token_material_list=[m1,m2]
	
	
func rebuild()->void:
	print("[",self.name,"]","rebuild ",[nb_column,nb_line])
	remove_all_token()
	init_board_value()
	column_height_index_array.clear()
	for c in get_children():remove_child(c)#clear all children
	for i in range(nb_column):
		#set column as empty
		column_height_index_array.append(0)
		
		for j in range(nb_line):
			var child:MeshInstance3D = MeshInstance3D.new()
			child.mesh=case_mesh
			child.set_surface_override_material(0,case_material)
			child.translate(Vector3(0,j,i))
			add_child(child)
	
func remove_all_token()->void:
	for c in get_children():
		remove_child(c)#clear all children (case + token)
	
#if nb_column is returned => coluln is full or invalid
func get_height_index(col_index:int)->int:
	if(col_index>=nb_column):return nb_line
	return column_height_index_array[col_index]

func spawn_token(col_index:int,player_index:int)->bool:
	var h_index = get_height_index(col_index)
	if h_index == nb_line:return false
	var token = Token.new(token_mesh,token_material_list[player_index],col_index,nb_line,h_index)
	add_child(token)
	var token_value=TOKEN_VALUE.PLAYER1+player_index
	board_value[col_index][h_index]=token_value
	#send data to the ruler to check victory
	ruler.token_added(col_index,h_index,token_value)
	column_height_index_array[col_index]+=1
	
	print("[",name,"] : spawn ",{"col":col_index,"h":h_index,"p":player_index})
	return true

func spawn_multiple_token_array(col_array:Array[int],player_index:int=0):
	for col in col_array:
		if spawn_token(col,player_index):player_index=1-player_index
	return player_index
		
#internal "event"
func on_export_change()->void:
	rebuild()
	pass

##DBG##################################


func _on_test_spawn_pressed():
	var col=randi()%nb_column
	var player=1+randi()%2
	var ret=spawn_token(col,player-1)
	print("[$",self.name,"][DBG]test spawn",{"column":col,"player":player,"return":ret})
pass # Replace with function body.

func _dbg_spawn_vertical_win():
	rebuild()
	init_ruler(ruler)
	spawn_multiple_token_array([0,1,1,0,5,3,5,3,5,1,5])
	
func _dbg_horizontal_win():
	rebuild()
	init_ruler(ruler)
	spawn_multiple_token_array([2,2,3,3,4,4,5])
	
func dbg_diagdown_win():
	rebuild()
	init_ruler(ruler)
	spawn_multiple_token_array([0,1,2,3,4,5,0,2,0,0,4,1,4,1])
	
func dbg_diagup_win():
	rebuild()
	init_ruler(ruler)
	spawn_multiple_token_array([0,1,1,3,2,2,2,3,3,4,3])
