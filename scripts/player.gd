extends entity

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	#test purpose
	nav_agent.set_target_location($"../target2".global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Test purpose PRESS "P"
func _input(event):
	if Input.is_key_pressed(KEY_P):
		if nav_agent.target_location == $"../target".global_position:
			nav_agent.set_target_location($"../target2".global_position)
		else:
			nav_agent.set_target_location($"../target".global_position)
