extends Resource
class_name ability_base

@export var id:String
@export var desc:String
@export var fx:Resource	#The visual effect, like a fireball or so
# Abilities may have a cast sound (played while you cast)
# and an hit sound (played when spell hits target)
@export var cast_sound:Resource
@export var hit_sound:Resource
@export var cooldown:float = 1.0

func use(owner, target):
	pass
