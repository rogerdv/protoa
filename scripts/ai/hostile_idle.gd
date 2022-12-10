extends BehaviorTreeAction
class_name hostile_idle

# Idle state

func tick():
	
	if actor.combat:
		return FAILURE
#	print("Idling")
	if actor.get_node("sensor").targets.size()>0:
		#check if we see a hostile
		for t in actor.get_node("sensor").targets:
			if t.align==actor.align*-1:	#is opposite align?
				actor.target=t
				actor.combat = true
				return FAILURE
	
	return SUCCESS
