@icon("res://addons/yagbta/icons/Blackboard.svg")
extends Resource
class_name Blackboard 


var data = {}


func set_data(key, value):
	data[key] = value


func get_data(key):
	return data[key]
