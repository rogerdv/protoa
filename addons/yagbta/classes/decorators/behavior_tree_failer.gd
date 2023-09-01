@icon("res://addons/yagbta/icons/BehaviorTreeFailer.svg")
extends BehaviorTreeDecorator
class_name BehaviorTreeFailer


func tick():
	var response = child_node.tick()
	if response == RUNNING:
		return RUNNING
	return FAILURE
