extends BehaviorTreeBranchedNode
class_name BehaviorTreeComposite
@icon("res://addons/yagbta/icons/BehaviorTreeComposite.svg")

var stack = []
var cursor = 0
@export var reactive:bool = false
var current_child_running = null

@export var random:bool = false

var stop_condition
var continue_condition

func _ready():
	stack = get_children()
	if random:
		stack.shuffle()

func tick():
	for i in range(len(stack) - cursor):
		var node_status = stack[i + cursor].tick()
		if node_status == stop_condition:
			cursor = 0
			if random:
				stack.shuffle()
			return stop_condition
		
		if node_status == RUNNING:
			
			if not reactive:
				cursor = i + cursor
				
			return RUNNING
			
	if random:
		stack.shuffle()
	cursor = 0
	return continue_condition
