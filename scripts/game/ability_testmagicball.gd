extends ability_base
class_name test_magicball

var model

func use(owner, target):
	model = fx.instantiate()
	model.damage = 3.1
	model.target = target
	# add the effect as child of the scene, not the player!
	owner.get_parent().add_child(model)
#	item_mesh.find_node("flash").global_transform.origin + owner_forward*1.5
	var pos =  owner.global_transform.origin + owner.global_transform.basis.z *1.5	
