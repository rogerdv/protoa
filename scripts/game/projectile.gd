extends Node3D

var damage = 1	#just in case
var target 
var rot = Vector3()
var speed = 1.9
var rotation_speed = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var direction = target.global_transform.origin - global_transform.origin
			
	direction = direction.normalized()
		
	var rot_amount =direction.cross(global_transform.basis.z)
	rot.y = rot_amount.y * rotation_speed * delta
	rot.x = rot_amount.x * rotation_speed * delta
	rotate(Vector3.UP,rot.y)
	rotate(Vector3.RIGHT,rot.x)
			
	global_translate(-global_transform.basis.z * speed *delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
