extends KinematicBody

onready var binoc = $BinocOverlay
onready var camera1 = $Head/Camera
onready var camera2 = $Head2/Camera
onready var ui = $UI
onready var head = $Head
onready var look = $Head/Camera/Look
onready var ground = $GroundCheck


var speed = 10
var acceleration = 10
var gravity = 0.09
var jump = 17

var mouse_sensitivity = 0.30

var input_vec = Vector2()
var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

var is_crouching = false
var is_upright = true
var is_thirdPerson = false
var is_idle = false

#States
var moving_left
var moving_right
var moving_forward
var moving_backward
var jumping

#Debug
var moving = false
var shouldMove = true
var coords
var is_holding_rifle = false
var is_holding_pistol = false
var is_holding_knife = false

export var fov_trans := 5
export var fov_base := 70
export var fov_zoom := 20

var curr_fov

func _ready():
	binoc.visible = false
	ui.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera1.make_current()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	_ui_update()
	_handle_input(delta)
	_handle_gravity(delta)
	_handle_movement(delta)
	
	coords = self.get_translation()

	moving_backward = false
	moving_forward = false
	moving_left = false
	moving_right = false
	jumping = false
	
	
	if moving == false:
		is_idle = true
	if moving == true:
		is_idle = false

	
	# Animations
	
	if is_idle == true:
		pass
	if moving_right == true:
		pass
	if moving_left == true:
		pass
	if moving_forward == true:
		pass
	if moving_backward == true:
		pass
	if jumping == true:
		pass
	if is_holding_knife == true:
		pass
	if is_holding_rifle == true:
		pass
	if is_holding_pistol == true:
		pass

#gravity gets it's own function
func _handle_gravity(delta):
	move_and_slide(fall, Vector3.UP)
	if !is_on_floor():
		fall.y -= gravity

# Input functions should be placed here
func _handle_input(delta):
	
	if Input.is_action_pressed("crouch"):
		jump = 5
		var size = Vector3(3, 2, 3)
		self.set_scale(size)
	else:
		jump = 10
		var regSize = Vector3(3, 3, 3)
		self.set_scale(regSize)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		jumping = true

	if Input.is_action_pressed("zoom"):
		$Crosshair.visible = false
		camera1.set_fov(lerp(camera1.get_fov(), fov_zoom, fov_trans * delta))
		binoc.visible = true
	else:
		$Crosshair.visible = true
		camera1.set_fov(lerp(camera1.get_fov(), fov_base, fov_trans * delta))
		binoc.visible = false


	if Input.is_action_pressed("debug"):
		ui.visible = true
	else:
		ui.visible = false
	
	if Input.is_action_pressed("cam"):
		camera2.make_current()
	else:
		camera1.clear_current()
		camera1.make_current()

	input_vec.y = Input.get_action_strength('move_backward') - Input.get_action_strength('move_forward')
	input_vec.x = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	input_vec = input_vec.normalized().rotated(-rotation.y)

# get direction and apply movement
func _handle_movement(delta):
	direction.z = input_vec.y
	direction.x = input_vec.x

	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 

# update ui?
func _ui_update():
	ui.lookcollide(look)
	ui.ismoving(moving)
	ui.isidle(is_idle)
	ui.floorcheck(ground)
	ui.updatecoords(coords)

func _on_Area_area_entered(area):
	fall.y = jump
