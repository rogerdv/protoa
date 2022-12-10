extends BehaviorTreeAction
class_name  see_player


func tick():	
	if actor.equip["weapon"]=="":
		# equip something
		actor.equip["weapon"]=="hammer"
		actor.inventory["hammer"]["item"].equip(actor)
	return SUCCESS
