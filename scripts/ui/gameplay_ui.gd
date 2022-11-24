extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func add_message(msg:String):
	var l = Label.new()
	l.text = msg
	$MessageArea/Text.add_child(l)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_instance.player.target!=null:
		var tname:String=game_instance.player.target.name
		$target.text = tname+"("+str(game_instance.player.target.hp[0])+"/"+str(game_instance.player.target.hp[1])+")"
	else :
		$target.text=""
		
