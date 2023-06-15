extends Control

signal action_emited(action:MainMenu.MainMenuActionEnum)
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _on_button_action(action:MainMenu.MainMenuActionEnum):
	if MainMenu.MainMenuActionEnum.find_key(action):
		emit_signal("action_emited",action)
	else :
		printerr("[$",self.name,"],Action number unknown : ",action)
	pass
