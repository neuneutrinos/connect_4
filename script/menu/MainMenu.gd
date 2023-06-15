extends Node
class_name MainMenu
@onready var board:Board=$Board_background
@export var frac_time_max:float
var frac_time:float=0

enum MainMenuActionEnum{NONE,PLAY,SETUP,QUIT}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frac_time-=delta
	if frac_time<=0 :
		frac_time=frac_time_max
		_on_time()
	pass

func _on_time():
	board._on_test_spawn_pressed()


func _on_button_action_emited(action):
	print("[MainMenu] action to process : ",MainMenuActionEnum.keys()[action])
	match action :
		MainMenuActionEnum.PLAY:
			print("[MainMenu] change scene to game")
			get_tree().change_scene_to_file("res://scene/level/game.tscn")
		MainMenuActionEnum.SETUP:
			print("[MainMenu] nope")
			pass
		MainMenuActionEnum.QUIT:
			get_tree().quit()
		
	pass # Replace with function body.
