extends Node3D

var camera 
const ray_length = 1000 #length of the raycast
var player
var char_s = preload("res://UI/character_sheet.tscn")
var cs	#character sheet
var inv_s = preload("res://UI/inventory.tscn")
var inv	# inventory window

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $"../pivot/Camera3D"
	player = game_instance.player
	

func _unhandled_input(event):
	#Raycasting for click position	
	if event is InputEventMouseButton and event.pressed :	
		# Clear player action queue
		player.actions.clear()	
		var space_state = get_world_3d().direct_space_state
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from,to))
		if event.button_index == 2:	
			#Right click
			if intersection != null:				
				player.move_to(intersection.position)
		
		elif event.button_index == 1:
			# LEft click, look for NPC or interactable
			if intersection != null:
				if intersection["collider"] is npc:	
					if player.target==null or player.target.name!=intersection["collider"].name: 				
						intersection["collider"].toggle_select(true)
						player.target = intersection["collider"]
						player.turn_at(player.target.global_transform.origin)						
					else :
						#target already selected
						#TODO: moe only if far away							
						if intersection["collider"].align>player.align:
							# Enemy, enable combat
							player.combat = true
							var w_rng:float = 1.5 #weapon range
							if player.equip["weapon"]!="":
								# get weapon range
#								print("Player equip weapon is ")
								w_rng=player.inventory[player.equip["weapon"]]["item"].range
							if player.position.distance_to(player.target.position)>w_rng:				
								player.move_to(intersection.position,w_rng,false) #keep distance and avoid overlaping
						else :
							# TODO: Open dialog
							if player.position.distance_to(player.target.position)>1.5:				
								player.move_to(intersection.position,1.5) #keep distance and avoid overlaping

				else:
					#clicked on ground, unselect current target
					if player.target!=null:
						player.target.toggle_select(false)
						player.target=null#		
	
func _unhandled_key_input(event):
	if  event is InputEventKey and event.pressed:
		if event.keycode==KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode==KEY_C:
			if cs==null:
				cs= char_s.instantiate()
				GlobalControl.scene_ui.add_child(cs)
			else :
				cs.queue_free()
		elif event.keycode==KEY_I:
			if inv==null:
				inv = inv_s.instantiate()
				GlobalControl.scene_ui.add_child(inv)
			else :
				inv.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
