extends Node
class_name BasicRuler

enum LINE_ENUM{HORIZONTAL=0,VERTICAL=1,DIAGUP=2,DIAGDOWN=3}
# Called when the node enters the scene tree for the first time.
var board_ref:Board# can't be none
var victory_token_array=[]
var token_score_array:Array

func on_win():
	print("[",name,"] WIN :",victory_token_array)
func on_ready():
	if board_ref == null :
		printerr("[BasicRuler] : board reference must be initialized")
	else :print("[BasicRuler] : ready !")
	victory_token_array.clear()
	for c in range(board_ref.nb_column) :
		token_score_array.append([])
		for l in range(board_ref.nb_line):
			#one score par line horizontal,vertical,diagup and diagdown
			token_score_array[c].append([0,0,0,0])

#TODO check duplication in win array (can only be the token col_index,height_index
func token_added(_col_index:int,_height_index:int,_player_index:Board.TOKEN_VALUE):
	update_score_horizontal(_col_index,_height_index,_player_index)
	update_score_vertical(_col_index,_height_index,_player_index)
	update_score_diagup(_col_index,_height_index,_player_index)
	update_score_diagdown(_col_index,_height_index,_player_index)
	

#agregation, update the score
func _agreg_update_score(good_token_coord_array:Array,score_id:LINE_ENUM)->void:
	var size = good_token_coord_array.size()
	for token_coord in good_token_coord_array:
		var c=token_coord.x
		var l=token_coord.y
		token_score_array[c][l][score_id]=size
	if size >= 4 :
		victory_token_array.append_array(good_token_coord_array)
		on_win()



func update_score_horizontal(col_index:int,height_index:int,player_index:int):
	var good_token_coord_array=[Vector2i(col_index,height_index)]
	var i=col_index-1
	while i>=0 && board_ref.board_value[i][height_index]==player_index :
		good_token_coord_array.append(Vector2i(i,height_index))
		i-=1
	
	i=col_index+1
	while i<board_ref.nb_column && board_ref.board_value[i][height_index]==player_index :
		good_token_coord_array.append(Vector2i(i,height_index))
		i+=1
	_agreg_update_score(good_token_coord_array,LINE_ENUM.HORIZONTAL)

func update_score_vertical(col_index:int,height_index:int,player_index:int):
	var good_token_coord_array=[Vector2i(col_index,height_index)]
	var i=height_index-1
	while i>=0 && board_ref.board_value[col_index][i]==player_index:
		good_token_coord_array.append(Vector2i(i,height_index))
		i-=1
	_agreg_update_score(good_token_coord_array,LINE_ENUM.VERTICAL)

func update_score_diagup(col_index:int,height_index:int,player_index:int):
	var good_token_coord_array=[Vector2i(col_index,height_index)]
	var c = col_index-1
	var l = height_index-1
	while c>=0 && l>=0 && board_ref.board_value[c][l]==player_index :
		good_token_coord_array.append(Vector2i(c,l))
		c-=1
		l-=1
		
	c= col_index+1
	l= height_index+1
	while c<board_ref.nb_column && l<board_ref.nb_line && board_ref.board_value[c][l]==player_index :
		good_token_coord_array.append(Vector2i(c,l))
		c+=1
		l+=1
	_agreg_update_score(good_token_coord_array,LINE_ENUM.DIAGUP)

func update_score_diagdown(col_index:int,height_index:int,player_index:int):
	var good_token_coord_array=[Vector2i(col_index,height_index)]
	var c = col_index-1
	var l = height_index+1
	while c>=0 && l<board_ref.nb_line && board_ref.board_value[c][l]==player_index :
		good_token_coord_array.append(Vector2i(c,l))
		c-=1
		l+=1
		
	c= col_index+1
	l= height_index-1
	while c<board_ref.nb_column && l>=0 && board_ref.board_value[c][l]==player_index :
		good_token_coord_array.append(Vector2i(c,l))
		c+=1
		l-=1
	_agreg_update_score(good_token_coord_array,LINE_ENUM.DIAGDOWN)

	




