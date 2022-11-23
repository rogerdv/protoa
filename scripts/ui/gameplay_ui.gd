extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_message(msg:String):
	var l = Label.new()
	l.text = msg
	$MessageArea/Text.add_child(l)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
