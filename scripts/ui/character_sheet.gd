extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	update_ui()
	$Panel/HBoxContainer/attribs/str/str_val.text_changed.connect(attrib_changed.bind(entity.STR))
	$Panel/HBoxContainer/attribs/int/int_val.text_changed.connect(attrib_changed.bind(entity.INT))
	$Panel/HBoxContainer/attribs/dex/dex_val.text_changed.connect(attrib_changed.bind(entity.DEX))
	$Panel/HBoxContainer/attribs/con/con_val.text_changed.connect(attrib_changed.bind(entity.CON))
	
func update_ui():
	$Panel/HBoxContainer/attribs/str/str_val.text = str(game_instance.player.attrib[entity.STR])
	$Panel/HBoxContainer/attribs/int/int_val.text = str(game_instance.player.attrib[entity.INT])
	$Panel/HBoxContainer/attribs/dex/dex_val.text = str(game_instance.player.attrib[entity.DEX])
	$Panel/HBoxContainer/attribs/con/con_val.text = str(game_instance.player.attrib[entity.CON])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func attrib_changed(new_val, attr):
	var val = new_val.to_int()
	game_instance.player.attrib[attr]=val
	game_instance.player.recalc_stats()

func _on_close_pressed():
	queue_free()

