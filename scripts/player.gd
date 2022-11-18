extends entity

# Called when the node enters the scene tree for the first time.
func _ready():
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#test purpose
	if GlobalControl.Lclick != Vector3.ZERO:
		nav_target(GlobalControl.Lclick)
