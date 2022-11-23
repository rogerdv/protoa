extends Node3D

var damage:float

func _on_area_3d_body_entered(body):
	pass
	#Play weapon sound
	#body bleeds on intersection
	#print("Hit ",body.name," for "+str(damage)+" damage")
	#body.hp[0]-=damage
	#GlobalControl.scene_ui.add_message("Hit")
