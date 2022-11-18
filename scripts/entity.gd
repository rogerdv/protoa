extends CharacterBody3D
class_name entity

#Lets add NavigationAgent3D trowgh code, accessible as 'nav_agent', 
#we don't need to interact with such node directly in the actual tree..
var nav_agent = NavigationAgent3D.new() #Navigation agent itself

var SPEED = 7.0 #speed factor *dah!

func _ready():
	add_child(nav_agent) #add as remote node

func _physics_process(delta):
	#Movement formula using navigation
	if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_location()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		velocity = new_velocity
		move_and_slide()

#Use this method for set navigation target, please dont set it directly.
func nav_target(target:Vector3):
	nav_agent.set_target_location(target)
