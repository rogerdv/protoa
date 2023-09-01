@icon("res://addons/yagbta/icons/BehaviorTreeParallel.svg")
extends BehaviorTreeComposite
class_name BehaviorTreeParallel


func tick():
	for node in stack:
		node.tick()
	
	if random:
		stack.shuffle()
	return SUCCESS
