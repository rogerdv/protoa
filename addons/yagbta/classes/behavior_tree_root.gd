@icon("res://addons/yagbta/icons/BehaviorTreeRoot.svg")
extends BehaviorTreeBranchedNode
class_name BehaviorTreeRoot 


@export var actor_path:NodePath
@export var active:bool = true
@export var tick_time:float = 0.5

@export var blackboard:Resource
var child_node

func _ready():
	
	if blackboard == null:
		blackboard = Blackboard.new()
	
	child_node = get_children()[0]
	
	var timer = Timer.new()
	timer.wait_time = tick_time
	add_child(timer)
	timer.timeout.connect(_on_tick_timer_timeout)
	timer.start()
	
	if actor_path.is_empty():
		actor = get_parent()
	else:
		actor = get_node(actor_path)
		
	tree_root = self
	
	setup_children(self, actor)
	if active:
		tick()

func activate():
	active = true
	tick()


func _on_tick_timer_timeout():
	tick()


func tick():
	child_node.tick()
