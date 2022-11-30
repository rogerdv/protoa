extends Node3D

var damage:float

func toggle_collisions(toggle):
	$hammer2/Area3D.monitoring = toggle
	
func _on_area_3d_body_entered(body):
	# play use sound
	$AudioStreamPlayer3D.play()
	# Disable colisions until next use
	$hammer2/Area3D.set_deferred("monitoring", false)
	#toggle_collisions(false)
	
	#body bleeds on intersection
	#print("Hit ",body.name," for "+str(damage)+" damage")
	var msg:String=body.name
	
	body.receive_dmg(damage,0)
	GlobalControl.scene_ui.add_message("Hit "+msg+" for "+str(damage)+" damage")
