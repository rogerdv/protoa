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
	$hp.text = str(game_instance.player.hp[0])+"/"+str(game_instance.player.hp[1])	


func _on_slot_pressed(extra_arg_0):
	if game_instance.player.abilities["testmb"]["cooldown"]<=0:		
		#we can cast
		for a in game_instance.abilities:
			if a["id"]=="testmb":
				a.use(game_instance.player, game_instance.player.target)
				game_instance.player.abilities["testmb"]["cooldown"]=a["cooldown"]
