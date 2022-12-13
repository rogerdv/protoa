extends BehaviorTreeAction
class_name  see_player


func tick():
	if not actor.combat	:
		return FAILURE
#	print("Before weapon slot=",actor.equip["weapon"])	
	if actor.equip["weapon"]=="":
#		print("no weapon equipped")
		# equip something		
		actor.inventory["stick"]["item"].equip(actor)
		actor.equip["weapon"]="stick"
#		print("Weapon slot=", actor.equip["weapon"])
	
	return SUCCESS
