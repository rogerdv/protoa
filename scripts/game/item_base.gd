extends Resource
class_name item_base

#Base class for all game items
@export var id:String
@export var desc:String
@export var mesh:Resource
@export var slot:String	#slot to put the item
@export var use_sfx:Resource	#sound effect when using the item
@export var use_time:float = 1.0	#time required to use the item

var model 

func use(owner, target):
	pass

func equip(owner):
	pass
