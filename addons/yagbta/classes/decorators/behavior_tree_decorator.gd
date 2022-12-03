extends BehaviorTreeBranchedNode
class_name BehaviorTreeDecorator
@icon("res://addons/yagbta/icons/BehaviorTreeDecorator.svg")

var child_node

func _ready():
	child_node = get_children()[0]
