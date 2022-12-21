extends BehaviorTreeAction
class_name move_to

# Move to weapon range

func tick():
	if actor.dead:
		return FAILURE
	var rng
	if actor.equip["weapon"]!="":
		rng=actor.inventory[actor.equip["weapon"]]["item"].range
	else :
		rng=1.5
	if actor.position.distance_to(actor.target.position)>rng:
		
		#workaround needs revision
		var dict_ = {"collider":actor.target}
		actor.move_to(dict_,rng, true)
		return RUNNING
	else : 
		var attack = {"type": "use_item", "id":actor.equip["weapon"],
							"timer":actor.inventory[actor.equip["weapon"]]["item"].use_time, 
							"cooldown":actor.inventory[actor.equip["weapon"]]["item"].use_time,
							"target":actor.target, "done":false, "loop":true}
		
		actor.actions.append(attack)
		print("IA: added action to ", actor.name)
		
		return SUCCESS
		
