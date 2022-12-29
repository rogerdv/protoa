extends Node3D

var damage:float
@export var area:NodePath
var owner_name=""		

func toggle_collisions(toggle):
	get_node(area).monitoring = toggle
	
func _on_area_3d_body_entered(body):
	print("Hit ", body.name)
	# Discard self hit
	if body.name==owner_name:
		return
	# play use sound
	$AudioStreamPlayer3D.play()
	# Disable colisions until next use
#	get_node(area).set_deferred("monitoring", false)
	#toggle_collisions(false)
	
	#body bleeds on intersection
	#print("Hit ",body.name," for "+str(damage)+" damage")
	var msg:String=body.name
	
	body.receive_dmg(damage,0)
	GlobalControl.scene_ui.add_message("Hit "+msg+" for "+str(damage)+" damage")
