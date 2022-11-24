extends Node3D

func _ready():
	GlobalControl.scene_ui = $UI
	# Temporary workaround. Actually, scenes take player from game_instance
	game_instance.player = $player
