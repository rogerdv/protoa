extends Resource
class_name item_base

#Base class for all game items
@export var id:String
@export var mesh:Resource
@export var slot:String	#slot to put the item

func use(owner, target):
	pass

func equip(owner):
	var model = mesh.instantiate()
	#Temporary workaround, replace with better code
	var attach = owner.actor.find_child("weapon", true)
	attach.add_child(model)
