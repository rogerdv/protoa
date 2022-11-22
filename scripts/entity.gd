extends CharacterBody3D
class_name entity

#Lets add NavigationAgent3D trowgh code, accessible as 'nav_agent', 
#we don't need to interact with such node directly in the actual tree..
var nav_agent = NavigationAgent3D.new() #Navigation agent itself

var SPEED = 7.0 #speed factor *dah!

@export var model_scene:String
var actor

# Attributes and such RPG stuff
var hp = [100,100] 	#hit points
var ep = [100,100] 	#energy points

const STR = 0
const INT = 1
const DEX = 2
const CON = 3
const CHR = 4

var attrib=[5,5,5,5,5]

#Target os tje entity I have selected, for attack or dialog
var target		
@export var inventory:Array

var moving = false	#is the entity moving?


func _ready():
	add_child(nav_agent) #add as remote node
	nav_target(global_transform.origin)
	actor = load(model_scene).instantiate()
	add_child(actor)

func move_to(pos:Vector3):
	moving = true
	nav_target(pos)
	actor.get_node("AnimationPlayer").play("run_forward_one_handed")

func smooth_rotate(pos:Vector3):
	var from = Quaternion(transform.basis)
	var to = Quaternion(transform.looking_at(pos).basis)
	transform.basis = Basis(from.slerp(to,0.1))
		
func _physics_process(delta):
	#Movement formula using navigation
	if not nav_agent.is_target_reached():
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_location()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		if not nav_agent.is_target_reachable() and current_location.round() == next_location.round():
			nav_target(current_location)
#			actor.get_node("AnimationPlayer").play("idle_one_handed")
			return
		
		#Smooth rotation
		var from = Quaternion(transform.basis)
		var to = Quaternion(transform.looking_at(next_location).basis)
		transform.basis = Basis(from.slerp(to,0.1))
		
		velocity = new_velocity
		move_and_slide()
	elif nav_agent.is_target_reached() and moving:
		moving = false
		actor.get_node("AnimationPlayer").play("idle_one_handed")
	

#Use this method for set navigation target, please dont set it directly.
func nav_target(target:Vector3):
	nav_agent.set_target_location(target)
