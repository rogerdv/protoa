extends BehaviorTreeComposite
class_name BehaviorTreeSequence
@icon("res://addons/yagbta/icons/BehaviorTreeSequence.svg")


func tick():
	stop_condition = FAILURE
	continue_condition = SUCCESS
	return super.tick()
