extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	update_list()


func update_list():
	# Display all items
	for it in game_instance.items:
		var line = HBoxContainer.new()
		var l=Label.new()
		l.text=tr(it.id)
		line.add_child(l)
		var add_b = Button.new()
		add_b.text="<"
		add_b.pressed.connect(to_inventory.bind(it))
		line.add_child(add_b)
		$cont/HBoxContainer/items.add_child(line)
	#
	#Display player inventory
	for id in game_instance.player.inventory.keys():
		var line = HBoxContainer.new()
		var eq_b = Button.new()
		eq_b.text="Equip"
		eq_b.pressed.connect(equip.bind(id))
		line.add_child(eq_b)
		var l=Label.new()
		l.text=tr(id)
		line.add_child(l)				
		$cont/HBoxContainer/player.add_child(line)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# add to player inventory
func to_inventory(item):
	if game_instance.player.inventory.has(item.id):
		#player has a similar item
		if item.stack:
			game_instance.player.inventory[item.id]["amount"]+=1
		else :
			var data= {"amount":1,"quality":1,"item":item}
			game_instance.player.inventory[item.id]=data
	else :
		var data= {"amount":1,"quality":1}
		game_instance.player.inventory[item.id]=data
		
	update_list()

func equip(id:String):
	var item = game_instance.get_item(id)
	game_instance.player.equip[item.slot]=id
					
func _on_close_pressed():
	queue_free()
