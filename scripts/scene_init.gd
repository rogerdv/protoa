extends Node3D

var menu = preload("res://UI/end_menu.tscn")
var end_game = false

func _ready():
	GlobalControl.scene_ui = $UI	
	add_child(game_instance.player)
	get_node("player").position=Vector3(0,0,0)

func _on_exit_exit_scene(next_scene):
	remove_child(get_node("player"))
	get_tree().change_scene_to_file(next_scene)
	
func _process(delta):
	if game_instance.player.dead and not end_game:
		end_game=true		
		var m = menu.instantiate()
		$UI.add_child(m)
		m.exit.connect(quit_game)
		remove_child(get_node("player"))

func quit_game():
	get_tree().quit()
