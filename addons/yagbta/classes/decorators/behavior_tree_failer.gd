extends BehaviorTreeDecorator
class_name BehaviorTreeFailer
@icon("res://addons/yagbta/icons/BehaviorTreeFailer.svg")

func tick():
	var response = child_node.tick()
	if response == RUNNING:
		return RUNNING
	return FAILURE
