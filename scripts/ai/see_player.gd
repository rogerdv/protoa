extends BehaviorTreeAction
class_name  see_player


func tick():
	if not actor.combat or actor.dead:
		return FAILURE
#	print("Before weapon slot=",actor.equip["weapon"])	
	if actor.equip["weapon"]=="":
#		print("no weapon equipped")
		# equip something		
		actor.inventory["steel_bsword"]["item"].equip(actor)
		actor.equip["weapon"]="steel_bsword"
#		print("Weapon slot=", actor.equip["weapon"])
	
	return SUCCESS
