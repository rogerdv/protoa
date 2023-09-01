@icon("res://addons/yagbta/icons/BehaviorTreeInverter.svg")
extends BehaviorTreeDecorator
class_name BehaviorTreeInverter 


func tick():
	var response = child_node.tick()
	if response == SUCCESS:
		return FAILURE
	elif response == FAILURE:
		return SUCCESS
	else:
		return RUNNING
