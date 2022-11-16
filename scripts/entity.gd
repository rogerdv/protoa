extends CharacterBody3D
class_name entity

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# An array of dictionaries
var actions = []
# {"type":use_item/use_ability, "item_id/ability_id":"id of item/ability"}


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	

	move_and_slide()
