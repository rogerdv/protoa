extends ability_base
class_name test_magicball

@export var damage:float=1
var model


func use(owner, target):
	owner.anim.set("parameters/OneShot/active", true )
	owner.ep[0]-=energy
	# play cast sound
	owner.get_node("AudioStreamPlayer3D").stream=cast_sound
	owner.get_node("AudioStreamPlayer3D").play()
	#create projectile effect and set values
	model = fx.instantiate()
	var level = owner.skills["elemental"]["level"]
	model.damage = damage*owner.attrib[entity.INT]/10+(damage*level/10)
	model.target = target
	model.hit_fx=hit_fx
	model.parent_entity=owner
	
	# add the effect as child of the scene, not the player!
	owner.get_parent().add_child(model)
	model.get_node("sfx").stream=hit_sound

	var pos =  owner.get_node("origin").global_transform.origin #- owner.global_transform.basis.z *1.2
	model.global_transform.origin = pos
	model.transform.basis = owner.transform.basis
	
		
