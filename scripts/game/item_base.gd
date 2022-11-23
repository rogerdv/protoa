extends Resource
class_name item_base

#Base class for all game items
@export var id:String
@export var mesh:Resource
@export var slot:String	#slot to put the item

var model 

func use(owner, target):
	pass

func equip(owner):
	model = mesh.instantiate()
	#Temporary workaround, replace with better code
	var attach:BoneAttachment3D = owner.actor.find_child(slot, true)
	if attach.get_child_count()>0:
		# Item is already equipped, remnove
		attach.remove_child(attach.get_child(0))
	else :
		attach.add_child(model)
