extends BehaviorTreeAction
class_name hostile_idle


func tick():
#	print("Idling")
	if actor.get_node("sensor").see:
		return FAILURE
	
	return SUCCESS
