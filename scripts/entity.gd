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

@export var attrib:Array[int]=[5,5,5,5,5]
var actions = []

#derived stats
var hp_regen:float=1.0
@export var player_class:String = "warrior" 
@export var align:int = 0 #use 1 for hostile, 0 for neutral

#Target, the entity I have selected, for attack or dialog
var target		
# Inventory structure:
# {"id":{"amount":1,"quality":1}}
@export var inventory:Array
# Abilities known to this entity
# { ability_id:{"cooldown":0}
# ability_id:{"cooldown":0}
# }
# When cooldown is 0, ability can be cast again
var abilities = {"testmb":{"cooldown":0.0},"test2":{"cooldown":0.0}}
var skills = {"swords":{"level":1},"combat":{"level":1},"elemental":{"level":1},
				"dodge":{"level":1}}

# Do not confuse faction and group!
# Faction is a global organization, a group is just local to current scene
@export var faction:String="none"
@export var group:int =0

var moving = false	#is the entity moving?
var combat = false	#are we in combat?
var autoatk:bool #true if player is attacking
# Set to locked to prevent player to respond to commands or NPCs to process 
# AI and move 
var locked = false
var dead = false
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
	#Run anim
#	if attacking:
#		anim.set("parameters/stance/blend_position", Vector2(0,0) )
#	else :
	anim.set("parameters/stance/blend_position", Vector2(0,1) )

#Void	smooth_rotate
#set the parameters for character to make a nice smooth rotation
func smooth_rotate(pos:Vector3,amount:float=ROTATION):
	var from = Quaternion(transform.basis)
	var to = Quaternion(transform.looking_at(pos).basis)
	transform.basis = Basis(from.slerp(to,amount))

# Process the action queue
func process_actions(delta):
	if actions.size()==0:
		return
	if target==null or target.dead:
		actions.clear()
		combat=false
		return
	# Always process top of the queue (index 0)
	if actions[0]["type"]=="use_item":
		#TODO: what item?
		if actions[0]["done"]:
			#the action was performed, now just wait
			# timer is the time left to remove or reset action
			actions[0]["timer"]-=delta
		else:
			actions[0]["done"]=true
			#execute the action
			#just in case, we request a target. 
			# Maybe selected target is not the destination of item/spell
			inventory[0].use(self, actions[0]["target"])
	elif actions[0]["type"]=="cast_ability":
		if actions[0]["done"]:
			#the action was performed, now just wait
			# timer is the time left to remove or reset action
			actions[0]["timer"]-=delta
		else:
			actions[0]["done"]=true
			#execute the action
			#just in case, we request a target. 
			# Maybe selected target is not the destination of item/spell
			for a in game_instance.abilities:
				if a["id"]==actions[0]["id"]:
					a.use(self, actions[0]["target"])
		
	if actions[0]["timer"]<=0:
		# remove if not loopable action (like attack)
		# remove if loopable, but there is another action queued
		if actions[0]["loop"] and actions.size()==1:
			# reset values
			actions[0]["timer"]=actions[0]["cooldown"]
			actions[0]["done"]=false
			return
		else :
			#remove
			actions.remove_at(0)
			return

func receive_dmg(damage:float, dmg_type:int):
	hp[0]-=damage

# Returns skill level
func get_skill(id:String)->int:
	if skills.has(id):
		return skills[id]["level"]
	else : 
		return 0
	
func _process(delta):		
	# update cooldowns in ability list
	if abilities.size()>0:
		for a in abilities.keys():
			if abilities[a]["cooldown"]>0:
				abilities[a]["cooldown"]-=delta
	
	# Process the action queue
	process_actions(delta)

func _physics_process(delta):
	#Movement formula using navigation
	if not nav_agent.is_target_reached():
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_location()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		turn_at(next_location)
		
		if not nav_agent.is_target_reachable() and current_location.round() == next_location.round():
			nav_target(current_location)
			return
		
		velocity = new_velocity
		move_and_slide()
	elif nav_agent.is_target_reached() and moving:
		moving = false
		if autoatk:
			anim.set("parameters/stance/blend_position", Vector2(0,0) )
		else :
			anim.set("parameters/stance/blend_position", Vector2(0,-1) )
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

