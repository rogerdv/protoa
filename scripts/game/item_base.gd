extends Resource
class_name item_base

#Base class for all game items
@export var id:String
@export var desc:String
@export var mesh:Resource
@export var slot:String	#slot to put the item
@export var use_sfx:Resource	#sound effect when using the item
@export var use_time:float = 1.0	#time required to use the item
@export var stack:bool=false	#can be stacked, like potions?

var model 

func use(owner, target):
	pass

func equip(owner):
	model = mesh.instantiate()
	model.get_node("AudioStreamPlayer3D").stream=use_sfx
	#Temporary workaround, replace with better code
	var attach:BoneAttachment3D = owner.actor.find_child(slot, true)
	if attach.get_child_count()>0:
		# Item is already equipped, remnove
		attach.remove_child(attach.get_child(0))
	else :
		attach.add_child(model)
