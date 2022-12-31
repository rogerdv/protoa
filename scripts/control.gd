extends Node

#var Lclick:Vector3 #currently unused

#store up to 4 selected players
var selected = [null,null,null,null]

var debug:bool #for debug purposes
var scene_ui
# Hold quickbuttons config
var buttons=[{"action":""},{"action":"attack"},{"action":"ability","id":"testmb" },{"action":""},
			{"action":""},{"action":""},{"action":""},{"action":""},{"action":""},
			{"action":""}]

var display_tut = true#if true, tips about gampley will be displayed on game start

func _ready():
	debug = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Executed when left click is pressed in game
func left_click(target:Vector3):
	if selected[0]:
		selected[0].nav_target(target)
