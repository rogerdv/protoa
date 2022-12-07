extends Node

var player 
var p_scene = preload("res://models/player.tscn")

@export var abilities:Array
@export var items:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	player = p_scene.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_ability(id:String):
	for a in abilities:
		if a.id==id:
			return a
	return null

func get_item(id:String):
	for it in items:
		if it.id==id:
			return it
	return null
