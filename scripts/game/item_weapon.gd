extends item_base
class_name item_weapon

@export var damage:float
@export var skill:String	# What skill influences this weapon

func use(owner, target):
	# Enable colisions
	model.toggle_collisions(true)
	var level = owner.get_skill(skill)
	var base_damage=damage*owner.attrib[entity.STR]/10
	model.damage=base_damage+base_damage*level/10
#	owner.actor.get_node("AnimationPlayer").play("attack_one_handed")
	owner.anim.set("parameters/OneShot/active", true )
