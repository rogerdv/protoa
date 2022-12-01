extends Node

var player 
var p_scene = preload("res://models/player.tscn")

@export var abilities:Array

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
