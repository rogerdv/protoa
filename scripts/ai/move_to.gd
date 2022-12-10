extends BehaviorTreeAction
class_name move_to

# Move to weapon range

func tick():
	var rng=actor.inventory[actor.equip["weapon"]]["item"].range
	if actor.position.distance_to(actor.target.position)>rng:
		print("movint to target")
		actor.move_to(actor.target.position.rng, true)
		return RUNNING
	else : 
		return SUCCESS
		
