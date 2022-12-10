extends Area3D

var see:bool=false
var targets=[]
var actor

# Called when the node enters the scene tree for the first time.
func _ready():
	actor = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Something entered sensor
func _on_body_entered(body):	
	if body is entity: 	#is an entity?
		targets.append(body)


func _on_body_exited(body):
	for i in range(targets.size()):
		if targets[i].name==body.name:
			targets.remove_at(i)
			break
