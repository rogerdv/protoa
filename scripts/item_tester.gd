extends Node3D

var player
var rot_l=false
var rot_r=false

# Called when the node enters the scene tree for the first time.
func _ready():
	player= game_instance.player
	add_child(player)
	update_item_list()

func update_item_list():
	for it in game_instance.items:
		var line = HBoxContainer.new()
		var l=Label.new()
		l.text=tr(it.id)
		line.add_child(l)
		var add_b = Button.new()
		add_b.text="equip"
		add_b.pressed.connect(equip.bind(it))
		line.add_child(add_b)
		$ui/items.add_child(line)

func equip(it):
	# TRansfer to inventory
	if player.inventory.has(it.id):
		#player has a similar item
		if it.stack:
			game_instance.player.inventory[it.id]["amount"]+=1
		else :
			var data= {"amount":1,"quality":1,"item":it}
			game_instance.player.inventory[it.id]=data
	else :
		var data= {"amount":1,"quality":1,"item":it}
		game_instance.player.inventory[it.id]=data
	player.inventory[it.id]["item"].equip(player)
	player.equip[it.slot]=it.id
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_A):
		$pivot.rotate(Vector3(0, 1,0),-1*delta)
	if Input.is_key_pressed(KEY_D):
		$pivot.rotate(Vector3(0, 1,0),1*delta)


func _on_attack_pressed():
	player.anim.set("parameters/Time Scale 2/scale", 0.2 )
	player.anim.set("parameters/OneShot/active", true )
