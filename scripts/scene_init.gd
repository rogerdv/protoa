extends Node3D

func _ready():
	GlobalControl.scene_ui = $UI	
	add_child(game_instance.player)
	get_node("player").position=Vector3(0,0,0)

func _on_exit_exit_scene(next_scene):
	remove_child(get_node("player"))
	get_tree().change_scene_to_file(next_scene)
	
