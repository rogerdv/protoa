@icon("res://addons/yagbta/icons/BehaviorTreeDecorator.svg")
extends BehaviorTreeBranchedNode
class_name BehaviorTreeDecorator


var child_node

func _ready():
	child_node = get_children()[0]
