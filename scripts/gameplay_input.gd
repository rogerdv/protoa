extends Node3D

var camera 
const ray_length = 1000 #length of the raycast

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $"../pivot/Camera3D"

func _input(event):
	#Raycasting for click position
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:
		var space_state = get_world_3d().direct_space_state
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from,to))
		if intersection != null:
			$"../player".move_to(intersection.position)
		#Send click information to the global control
#		if GlobalControl.debug: print("Left click on: " + str(intersection.position))
#		if intersection != null:
#			#GlobalControl.Lclick = intersection.position
#			GlobalControl.left_click(intersection.position)
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
