extends Control

var icon_attack=load("res://textures/ui/sword.png")
var icon_spell=load("res://textures/ui/tome.png")
var l_set =LabelSettings.new()
var scrollbar


# Called when the node enters the scene tree for the first time.
func _ready():
	$"slot_bar/1".texture_progress=icon_attack 
	$"slot_bar/2".texture_progress=icon_spell 
	scrollbar=$MessageArea.get_v_scroll_bar()
	scrollbar.changed.connect(handle_scroll)

func add_message(msg:String):
	l_set.font_color = Color(0.1,.01,0.1,1)
	var l = Label.new()
	l.label_settings = l_set
	l.text = msg
	$MessageArea/Text.add_child(l)


func handle_scroll():
	$MessageArea.scroll_vertical = scrollbar.max_value		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_instance.player.target!=null:
		var tname:String=game_instance.player.target.name
		$target.text = tname+"("+str(game_instance.player.target.hp[0])+"/"+str(game_instance.player.target.hp[1])+")"
	else :
		$target.text=""
	$info/hp.text = str(game_instance.player.hp[0])+"/"+str(game_instance.player.hp[1])	
	$info/ep.text = str(game_instance.player.ep[0])+"/"+str(game_instance.player.ep[1])	
	# Update cooldowns
	# Temporary workaround
	for t in range(0,9):
		if GlobalControl.buttons[t]["action"]=="ability":
			if game_instance.player.abilities[GlobalControl.buttons[t]["id"]]["cooldown"]>0:
				#ability cooldown
				var ab_cooldown = game_instance.get_ability(GlobalControl.buttons[t]["id"]).cooldown
				# player cooldown for that ability
				var pl_cooldown = game_instance.player.abilities[GlobalControl.buttons[t]["id"]]["cooldown"]
				var perc:float = pl_cooldown/ab_cooldown*100
				get_node("slot_bar/"+str(t)).value=100-perc

func exec_slot(slot_idx:int):
	match GlobalControl.buttons[slot_idx]["action"]:
		"attack":
			#VEry basic action to test attack
			if game_instance.player.target==null:
				return
			var weapon_id =game_instance.player.equip["weapon"]
			var attack = {"type": "use_item", "id":weapon_id,
							"timer":game_instance.player.inventory[weapon_id]["item"].use_time, 
							"cooldown":game_instance.player.inventory[weapon_id]["item"].use_time,
							"target":game_instance.player.target, "done":false, "loop":true}
			game_instance.player.actions.append(attack)
		"ability":			
			if game_instance.player.abilities[GlobalControl.buttons[slot_idx]["id"]]["cooldown"]<=0:		
				#we can cast, if has a target
				if game_instance.player.target==null:
					return
				for a in game_instance.abilities:
					if a["id"]==GlobalControl.buttons[slot_idx]["id"]:
						a.use(game_instance.player, game_instance.player.target)
						game_instance.player.abilities[GlobalControl.buttons[slot_idx]["id"]]["cooldown"]=a["cooldown"]

func _on_slot_pressed(extra_arg_0):	
	exec_slot(extra_arg_0)
	

