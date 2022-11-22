extends Node3D

var camera 
const ray_length = 1000 #length of the raycast
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $"../pivot/Camera3D"
	player = $"../player"

func _input(event):
	#Raycasting for click position
	if event is InputEventMouseButton and event.pressed :
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
					intersection["collider"].toggle_select(true)
					player.target = intersection["collider"]
					player.smooth_rotate(player.target.global_transform.origin)
				else:
					#clicked on ground, unselect current target
					if player.target!=null:
						player.target.toggle_select(false)
					player.target=null		
		
	elif  event is InputEventKey:
		### TEST Remove!!!!!!!!!!!!!
		if event.keycode==KEY_1:
			player.inventory[0].equip($"../player")
		elif event.keycode==KEY_2:
			player.smooth_rotate(player.target.position)
			player.inventory[0].use(player, player.target)
#		### TEST Remove!!!!!!!!!!!!!

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
