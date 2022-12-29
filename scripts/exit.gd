extends Node3D

@export var next_scene:String

signal exit_scene

func _on_area_3d_body_entered(body):
	if body.name!="player":
		return
	# remove player, just in case
	emit_signal("exit_scene", next_scene)
	
