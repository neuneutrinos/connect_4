extends Node

@onready var board:Board=$Board
@export var frac_time_max:float
var frac_time:float=0
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
