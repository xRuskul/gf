extends KinematicBody

var speed = 10
var acceleration = 10
var gravity = 0.09
var jump = 17

var mouse_sensitivity = 0.30

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

var is_crouching = false
var is_upright = true
var is_thirdPerson = false
var is_idle = false

var moving_left
var moving_right
var moving_forward
var moving_backward
var jumping

onready var binoc = get_node("BinocOverlay")
onready var camera1 = get_node("Head/Camera")
onready var camera2 = get_node("Head2/Camera")
onready var ui = get_node("UI")
onready var head = $Head
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
	var iscollide = $Head/Camera/Look.is_colliding()
	var flrcheck = $GroundCheck.is_colliding()
	ui.lookcollide(iscollide)
	moving_backward = false
	moving_forward = false
	moving_left = false
	moving_right = false
	jumping = false
	var moving = false
	var shouldMove = true
	var cords = self.get_translation()
	var is_holding_rifle = false
	var is_holding_pistol = false
	var is_holding_knife = false
	ui.updatecords(cords)
	direction = Vector3()
	move_and_slide(fall, Vector3.UP)
	if not is_on_floor():
		fall.y -= gravity
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		jumping = true
	if Input.is_action_pressed("move_forward"):
		if shouldMove == true:
			direction -= transform.basis.z
			moving = true
			moving_forward = true
	elif Input.is_action_pressed("move_backward"):
		if shouldMove == true:
			direction += transform.basis.z
			moving = true
			moving_backward = true
	if Input.is_action_pressed("move_left"):
			if shouldMove == true:
				direction -= transform.basis.x
				moving = true
				moving_left = true
	elif Input.is_action_pressed("move_right"):
			if shouldMove == true:
				direction += transform.basis.x
				moving = true
				moving_right = true
	if Input.is_action_just_pressed("crouch"):
		jump = 5
		var size = Vector3(3, 2, 3)
		self.set_scale(size)
	if Input.is_action_just_released("crouch"):
		jump = 10
		var regSize = Vector3(3, 3, 3)
		self.set_scale(regSize)
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 
	if Input.is_action_just_pressed("zoom"):
		$Crosshair.visible = false
		camera1.fov = 20
		binoc.visible = true
	if Input.is_action_just_released("zoom"):
		camera1.fov = 70
		$Crosshair.visible = true
		binoc.visible = false
	if Input.is_action_just_pressed("debug"):
		ui.visible = true
	if Input.is_action_just_released("debug"):
		ui.visible = false
	
	if Input.is_action_just_pressed("cam"):
		camera2.make_current()
	if Input.is_action_just_released("cam"):
		camera1.clear_current()
		camera1.make_current()
	if moving == false:
		is_idle = true
	if moving == true:
		is_idle = false
	ui.ismoving(moving)
	ui.isidle(is_idle)
	ui.floorcheck(flrcheck)
	
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


func _on_Area_area_entered(area):
	fall.y = jump
