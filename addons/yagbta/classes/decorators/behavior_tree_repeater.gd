extends BehaviorTreeDecorator
class_name BehaviorTreeRepeater
@icon("res://addons/yagbta/icons/BehaviorTreeRepeater.svg")

@export var times:int = 1
var max_times

func _ready():
	max_times = times

func tick():
	var current_status = child_node.tick()
	if current_status == RUNNING:
		return RUNNING
	
	times = clamp(times - 1, 0, max_times)
	if times == 0:
		times = max_times
		return SUCCESS
	
	return RUNNING
	
