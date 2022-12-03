extends Node
class_name BehaviorTreeNode 
@icon("res://addons/yagbta/icons/BehaviorTreeNode.svg")

var tree_root = null
var actor = null
enum {FAILURE, SUCCESS, RUNNING}
var status = SUCCESS

func tick():
	pass
