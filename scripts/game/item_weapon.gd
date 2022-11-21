extends item_base
class_name item_weapon

@export var damage:float

func use(owner, target):
	target.hp[0]-=damage
