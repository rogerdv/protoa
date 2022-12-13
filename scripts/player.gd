extends entity
class_name player

var xp:int=0
@export var model_scene:String

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	actor = load(model_scene).instantiate()
	anim=actor.get_node("AnimationTree")
	add_child(actor)
	
	align=-1
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

