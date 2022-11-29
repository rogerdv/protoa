extends Node3D

func _ready():
	GlobalControl.scene_ui = $UI
	
	add_child(game_instance.player)
	
