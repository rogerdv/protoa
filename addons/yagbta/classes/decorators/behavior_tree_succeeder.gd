@icon("res://addons/yagbta/icons/BehaviorTreeSucceeder.svg")
extends BehaviorTreeDecorator
class_name BehaviorTreeSucceeder


func tick():
	var response = child_node.tick()
	if response == RUNNING:
		return RUNNING
	return SUCCESS
