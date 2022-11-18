extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#Raycasting Variables
@onready var camera = $Camera3D
const ray_length = 1000 #length of the raycast

const SCROLL_SPEED = 10
var UP:bool = false
var DOWN:bool = false
var LEFT:bool = false
var RIGHT:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask&(MOUSE_BUTTON_MASK_MIDDLE):
			self.rotate(Vector3(0, 1,0),event.relative.x * -0.002)
		if event.position.x==0:
			#self.translate(Vector3(-1,0,0))
			LEFT=true
		elif event.position.x>DisplayServer.window_get_size().x-5:
			#self.translate(Vector3(1,0,0))			
			RIGHT=true
		else:
			LEFT = false
			RIGHT = false 		
			
		if event.position.y==0:
			UP=true
		elif event.position.y>DisplayServer.window_get_size().y-5:
			DOWN=true
		
		else:
			UP=false
			DOWN=false 
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				#zoom
				if $Camera3D.size<18:
					$Camera3D.size+=0.5
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if $Camera3D.size>10:
					$Camera3D.size-=0.5
			
	#Raycasting for click position
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:
		var space_state = get_world_3d().direct_space_state
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from,to))
		
		#Send click information to the global control
		if GlobalControl.debug: print("Left click on: " + str(intersection.position))
		if intersection != null:
			#GlobalControl.Lclick = intersection.position
			GlobalControl.left_click(intersection.position)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_W) or UP:		
		self.translate(Vector3(0,0,-SCROLL_SPEED*delta))
		#get_node("Camera").look_at(Vector3(translation.x, translation.y, translation.z))
	if Input.is_key_pressed(KEY_S) or DOWN:		
		self.translate(Vector3(0,0,SCROLL_SPEED*delta))
		#get_node("camera").look_at(Vector3(translation.x, translation.y, translation.z))
	if (Input.is_key_pressed(KEY_A) or LEFT):		
		self.translate(Vector3(-SCROLL_SPEED*delta,0,0))
	if (Input.is_key_pressed(KEY_D) or RIGHT):		
		self.translate(Vector3(SCROLL_SPEED*delta,0,0))
	if Input.is_key_pressed(KEY_Q):
		self.rotate(Vector3(0, 1,0),-1*delta)
	if Input.is_key_pressed(KEY_E):
		self.rotate(Vector3(0, 1,0),1*delta)
		
