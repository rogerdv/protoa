extends entity
class_name npc

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	inventory["hammer"]={"amount":1,"quality":1, "item":game_instance.get_item("hammer")} 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	if hp[0]<=0 and not dead:		
		dead=true
		var t=Timer.new()		
		t.wait_time=1
		add_child(t)
		t.start()
		t.timeout.connect(_dead_timer)
	if dead:
		return

func toggle_select(selected:bool):
	$select.visible=selected

func _dead_timer():
	print("Dead timer")
	queue_free()
