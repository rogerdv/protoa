@icon("res://addons/yagbta/icons/BehaviorTreeBranchedNode.svg")
extends BehaviorTreeNode
class_name BehaviorTreeBranchedNode 


func setup_children(root, actor):
	self.actor = actor
	var assing_id = 0
	for node in get_children():
		if node is BehaviorTreeNode:
			node.tree_root = root
			node.actor = actor
			assing_id += 1
			if node.has_method("setup_children"):
				node.setup_children(root, actor)
