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
#
#func equip(owner):
#
#	model = mesh.instantiate()
#	model.get_node("AudioStreamPlayer3D").stream=use_sfx
#	#Temporary workaround, replace with better code
#	var attach:BoneAttachment3D = owner.actor.find_child(slot, true)
#	if attach.get_child_count()>0:
#		# Item is already equipped, remnove
#		attach.remove_child(attach.get_child(0))
#	else :
#		attach.add_child(model)
