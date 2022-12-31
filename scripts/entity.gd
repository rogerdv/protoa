extends CharacterBody3D
class_name entity

#Lets add NavigationAgent3D trowgh code, accessible as 'nav_agent', 
#we don't need to interact with such node directly in the actual tree..
var nav_agent = NavigationAgent3D.new() #Navigation agent itself
var nav_target #stores character for position updates
var anim 

var SPEED = 7.0 #speed factor *dah!
var ROTATION = 0.2 #amount of rotation


var actor


# Attributes and such RPG stuff
var hp = [100.0,100.0] 	#hit points
var ep = [100.0,100.0] 	#energy points

const STR = 0
const INT = 1
const DEX = 2
const CON = 3
const CHR = 4

@export var level:int = 1
@export var attrib:Array[int]=[5,5,5,5,5]
var actions = []

#derived stats
var hp_regen:float=1.0
var ep_regen:float=1.0
@export var player_class:String = "warrior" 
@export var align:int = 0 #use 1 for hostile, 0 for neutral

#Target, the entity I have selected, for attack or dialog
var target		
# Inventory structure:
# {"id":{"amount":1,"quality":1}}
var inventory={}

#equipped items
# {slot:it_id}
var equip = {"head":"","weapon":"","armor":""}

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

var regen_counter = 0

func _ready():
	#nav config
	add_child(nav_agent) #add as remote node
	set_nav_agent(global_transform.origin)
		
	recalc_stats()

# Recalculate derived stats
func recalc_stats():
	hp[1]=5*attrib[CON]+attrib[STR]*2
	hp[0]=hp[1]
	hp_regen = attrib[CON]/100.0
	print("HP regeneration calc: ", hp_regen)
	ep[1]= 5*attrib[INT]+attrib[CON]*2
	ep[0]=ep[1]
	ep_regen = attrib[CON]/100.0+attrib[INT]/100.0
	print("EP regeneration calc: ", ep_regen)

#Void	move_to
#set the parameters for character navigation
#Parameters:
#
#Dictionary 	_target
#Information about target
#
#float		separation	[default:0.1]
#the separation between character and target.
#
#bool		attacking	[default:false]
#set to true when moving to attack another character
func move_to(_target:Dictionary,separation:float=0.2,attacking:bool=false):
	autoatk = attacking
	moving = true
	nav_agent.target_desired_distance = separation
	#in case target is another character, store the node for update his position
	if _target["collider"] is entity:
		nav_target = _target["collider"]
	else:
	#in case not. just go to target position
		nav_target = null
		set_nav_agent(_target.position)
	#Run anim
#	if attacking:
#		anim.set("parameters/stance/blend_position", Vector2(0,0) )
#	else :
	anim.set("parameters/stance/blend_position", Vector2(0,1) )

#Void	smooth_rotate
#set the parameters for character to make a nice smooth rotation
func smooth_rotate(pos:Vector3,lockY:bool=false,amount:float=ROTATION):
	var from = Quaternion(transform.basis)
	if lockY:
		pos.y = global_transform.origin.y
	var to = Quaternion(transform.looking_at(pos).basis).normalized()
	
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
			turn_at(actions[0]["target"].position)
			if actions[0]["id"]!="":
#				print("Target is ",actions[0]["target"].name)
				inventory[actions[0]["id"]]["item"].use(self, actions[0]["target"])
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

# Calculates damage received
func receive_dmg(damage:float, dmg_type:int):
	if damage-get_protection(dmg_type)<0:
		return
	hp[0]=hp[0]-(damage-get_protection(dmg_type))

# Returns the total protection for a given damage type
func get_protection(dmg_type:int):
	var prot:float=0.0
	if equip["armor"]!="":
		prot+=inventory[equip["armor"]]["item"].prot
	if equip["head"]!="":
		prot+=inventory[equip["head"]]["item"].prot
#	print("Protection is ", prot)
	return prot
	
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
	if not dead:
		process_actions(delta)
	regen_counter+=delta
	if regen_counter>1:
		regen_counter=0
		
		if hp[0]<hp[1]:			
			hp[0]+=hp_regen
			print("Regenerating life ", hp_regen)
		else :
			hp[0]=hp[1]
		if ep[0]<ep[1]:
			ep[0]+=attrib[INT]/100+attrib[CON]/100

func _physics_process(delta):
	var w_rng=1.5	#weapon range
	if equip["weapon"]!="":
		w_rng=inventory[equip["weapon"]]["item"].range
	#if is stored a character as target refresh his location
	if nav_target and position.distance_to(nav_target.position)>=w_rng:
			set_nav_agent(nav_target.position)
	
	#do movement
	movement()
	
	#Smooth rotation with Y axis locked
	smooth_rotate(face_target,true)
	

func movement():
	#Movement formula using navigation
	if not nav_agent.is_target_reached():
		var current_location = global_transform.origin
		
		#calculate floor point from navmesh
		var next_nav_location = nav_agent.get_next_location()
		var space_state = get_world_3d().get_direct_space_state()
		var floor_ray = PhysicsRayQueryParameters3D.create(next_nav_location,Vector3(0,-1000,0))
		var intersection = space_state.intersect_ray(floor_ray)
		
		var next_location
		if intersection:
			next_location = intersection.position
		turn_at(next_location)
		
		if not nav_agent.is_target_reachable() and current_location.round() == next_location.round():
			set_nav_agent(current_location)
			return
			
		var new_velocity = (next_location - current_location).normalized() * SPEED
		set_velocity(new_velocity)
		move_and_slide()
	
	elif nav_agent.is_target_reached() and moving:
		moving = false
		nav_target=null
		if autoatk:
			anim.set("parameters/stance/blend_position", Vector2(0,0) )
			
			#create an attack action
			var weapon_id = equip["weapon"]
			var attack = {"type": "use_item", "id":weapon_id,
							"timer":inventory[weapon_id]["item"].use_time, 
							"cooldown":inventory[weapon_id]["item"].use_time,
							"target":target, "done":false, "loop":true}
			actions.append(attack)
		else :
			anim.set("parameters/stance/blend_position", Vector2(0,-1) )

#Use this method for set navigation target, please dont set it directly.
func set_nav_agent(target:Vector3):
	nav_agent.set_target_location(target)

#void	turn_at
#the default method to set where character should be facing.
func turn_at(_target:Vector3):
	face_target = _target

# enters combat mode. Takes care of setting the righ stance acording to weapon, etc	
func set_combat(toggle:bool):
	combat=toggle
	
