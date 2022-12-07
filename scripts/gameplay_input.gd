extends Node3D

var camera 
const ray_length = 1000 #length of the raycast
var player
var char_s = preload("res://UI/character_sheet.tscn")
var inv_s = preload("res://UI/inventory.tscn")

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
						player.move_to(intersection.position,1.5,true) #keep distance and avoid overlaping
#					

				else:
					#clicked on ground, unselect current target
					if player.target!=null:
						player.target.toggle_select(false)
						player.target=null#		
	
func _unhandled_key_input(event):
	if  event is InputEventKey and event.pressed:
		### TEST Remove!!!!!!!!!!!!!
		if event.keycode==KEY_1:
			player.inventory[0].equip(player)
		elif event.keycode==KEY_2:
			if player.target!=null:
				player.turn_at(player.target.position)
			#player.inventory[0].use(player, player.target)
			var action ={"type": "use_item", "id":player.inventory[0]["id"],
							"timer":player.inventory[0]["use_time"], 
							"cooldown":player.inventory[0]["use_time"],
							"target":player.target, "done":false, "loop":true}
			player.actions.append(action)
		elif event.keycode==KEY_3:			

			if player.abilities["testmb"]["cooldown"]<=0:				
				#we can cast
				
				for a in game_instance.abilities:
					if a["id"]=="testmb":
						var action ={"type": "cast_ability", "id":"testmb",
							"timer":a["cast_time"], 
							"cooldown":a["cooldown"],
							"target":player.target, "done":false, "loop":false}
						player.actions.append(action)
						player.abilities["testmb"]["cooldown"]=a["cooldown"]
		elif event.keycode==KEY_4:
			player.inventory[1].equip(player)

#		### TEST Remove!!!!!!!!!!!!!
		elif event.keycode==KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode==KEY_C:
			var cs= char_s.instantiate()
			GlobalControl.scene_ui.add_child(cs)
		elif event.keycode==KEY_I:
			var inv = inv_s.instantiate()
			GlobalControl.scene_ui.add_child(inv)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
