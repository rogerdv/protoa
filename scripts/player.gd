extends entity

@export var model_scene:String
var actor

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	actor = load(model_scene).instantiate()
	add_child(actor)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_event(camera, event, position, normal, shape_idx):
	#Selects player
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		GlobalControl.selected[0] = get_node(".")
