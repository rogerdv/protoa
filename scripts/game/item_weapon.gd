extends item_base
class_name item_weapon

@export var damage:float

func use(owner, target):
	# Enable colisions
	model.toggle_collisions(true)
	model.damage=damage
#	owner.actor.get_node("AnimationPlayer").play("attack_one_handed")
	owner.anim.set("parameters/OneShot/active", true )
