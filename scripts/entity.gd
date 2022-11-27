extends CharacterBody3D
class_name entity

#Lets add NavigationAgent3D trowgh code, accessible as 'nav_agent', 
#we don't need to interact with such node directly in the actual tree..
var nav_agent = NavigationAgent3D.new() #Navigation agent itself
var anim 

var SPEED = 7.0 #speed factor *dah!
var ROTATION = 0.2 #amount of rotation

@export var model_scene:String
var actor


# Attributes and such RPG stuff
var hp = [100.0,100.0] 	#hit points
var ep = [100.0,100.0] 	#energy points

const STR = 0
const INT = 1
const DEX = 2
const CON = 3
const CHR = 4

@export var attrib=[5,5,5,5,5]
var actions = []
#derived stats
var hp_regen:float=1.0

#Target os tje entity I have selected, for attack or dialog
var target		
@export var inventory:Array
# Abilities known to this entity
# { ability_id:{"cooldown":0}
# ability_id:{"cooldown":0}
# }
# When cooldown is 0, ability can be cast again
var abilities = {"testmb":{"cooldown":0.0},"test2":{"cooldown":0.0}}

# Do not confuse faction and group!
# Faction is a global organization, a group is just local to current scene
@export var faction:String="none"
@export var group:int =0

var moving = false	#is the entity moving?
var autoatk:bool #true if player is attacking

#just store here a position then player turn facing it
var face_target:Vector3 

func _ready():
	add_child(nav_agent) #add as remote node
	nav_target(global_transform.origin)
	actor = load(model_scene).instantiate()
	add_child(actor)
	anim=actor.get_node("AnimationTree")
	recalc_stats()

# Recalculate derived stats
func recalc_stats():
	hp[1]=10*attrib[CON]*attrib[STR]/10
	hp[0]=hp[1]
	hp_regen = attrib[CON]/100
	ep[1]= 5*attrib[INT]*attrib[CON]/10
	ep[0]=ep[1]
	
#Void	move_to
#set the parameters for character navigation
#Parameters:
#
#Vector3	pos
#the position character will try to reach
#
#float		separation	[default:0.1]
#the separation between character and target.
#
#bool		attacking	[default:false]
#set to true when moving to attack another character
func move_to(pos:Vector3,separation:float=0.1,attacking:bool=false):
	autoatk = attacking
	moving = true
	nav_agent.target_desired_distance = separation
	nav_target(pos)
#	actor.get_node("AnimationPlayer").play("run_forward_one_handed")
	#Run anim
	if attacking:
		anim.set("parameters/stance/blend_position", Vector2(0,0) )
	else :
		anim.set("parameters/stance/blend_position", Vector2(0,1) )

#Void	smooth_rotate
#set the parameters for character to make a nice smooth rotation
func smooth_rotate(pos:Vector3,amount:float=ROTATION):
	var from = Quaternion(transform.basis)
	var to = Quaternion(transform.looking_at(pos).basis)
	transform.basis = Basis(from.slerp(to,amount))

func _process(delta):
	if autoatk and nav_agent.is_target_reached():auto_attack()
	
	# update cooldowns in ability list
	if abilities.size()>0:
		for a in abilities.keys():
			if abilities[a]["cooldown"]>0:
				abilities[a]["cooldown"]-=delta

func _physics_process(delta):
	#Movement formula using navigation
	if not nav_agent.is_target_reached():
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_location()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		turn_at(next_location)
		
		if not nav_agent.is_target_reachable() and current_location.round() == next_location.round():
			nav_target(current_location)
#			actor.get_node("AnimationPlayer").play("idle_one_handed")
			return
		
		velocity = new_velocity
		move_and_slide()
	elif nav_agent.is_target_reached() and moving:
		moving = false
#		actor.get_node("AnimationPlayer").play("idle_one_handed")
		anim.set("parameters/stance/blend_position", Vector2(1,0) )
		if GlobalControl.debug:print(nav_agent.distance_to_target())
	
	#Smooth rotation
	smooth_rotate(face_target)
	

#Use this method for set navigation target, please dont set it directly.
func nav_target(target:Vector3):
	nav_agent.set_target_location(target)

#void	turn_at
#the default method to set where character should be facing.
func turn_at(target:Vector3):
	face_target = target

# Needs to be reworked, AnimationTree doesnt supports signals
# maybe check custom animation tracks?
func auto_attack():
	actor.get_node("AnimationPlayer").animation_finished.connect(_atk_animation_ends)
	inventory[0].use(self, target)
#workaround needs brainstorm
func _atk_animation_ends(anim_name):
	if anim_name == ("attack_one_handed"):
		print(target.name," takes: ",inventory[0].damage," damage")
		GlobalControl.scene_ui.add_message("Hit")
