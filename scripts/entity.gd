extends CharacterBody3D
class_name entity

#Lets add NavigationAgent3D trowgh code, accessible as 'nav_agent', 
#we don't need to interact with such node directly in the actual tree..
var nav_agent = NavigationAgent3D.new() #Navigation agent itself

var SPEED = 7.0 #speed factor *dah!

func _ready():
	add_child(nav_agent) #add as remote node
	nav_target(global_transform.origin)

func _physics_process(delta):
	#Movement formula using navigation
	if not nav_agent.is_target_reached():
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_location()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		if not nav_agent.is_target_reachable() and current_location.round() == next_location.round():
			nav_target(current_location)
			return
		
		#Smooth rotation
		var rot_temp = rotation #store actual rotation
		
		look_at(next_location,Vector3.UP) #get the wanter rotation
		var rot_wanted = rotation
		
		rotation = rot_temp #restore rotation
		
		var tween = create_tween() #tweened for smmothness
		tween.tween_property(self,":rotation",rot_wanted,0.3)
		
		
		velocity = new_velocity
		move_and_slide()
	

#Use this method for set navigation target, please dont set it directly.
func nav_target(target:Vector3):
	nav_agent.set_target_location(target)
