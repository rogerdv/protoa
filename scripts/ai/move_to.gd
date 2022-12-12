extends BehaviorTreeAction
class_name move_to

# Move to weapon range

func tick():
	var rng
	if actor.equip["weapon"]!="":
		rng=actor.inventory[actor.equip["weapon"]]["item"].range
	else :
		rng=1.5
	if actor.position.distance_to(actor.target.position)>rng:
		print("movint to target")
		actor.move_to(actor.target.position,rng, true)
		return RUNNING
	else : 
		var attack = {"type": "use_item", "id":actor.equip["weapon"],
							"timer":actor.inventory[actor.equip["weapon"]]["item"].use_time, 
							"cooldown":actor.inventory[actor.equip["weapon"]]["item"].use_time,
							"target":actor.target, "done":false, "loop":true}
		actor.actions.append(attack)
		return SUCCESS
		
