extends KinematicBody

export(Resource) var player_stats

export(NodePath) onready var collider
onready var binoc = $BinocOverlay
onready var camera1 = $Head/Camera_FPS
onready var camera2 = $Head/Camera_TPS
onready var ui = $UI
onready var crosshair = $Crosshair
onready var head = $Head
onready var look = $Head/Camera_FPS/Look
onready var ground = $CollisionShape/GroundCheck
onready var wepManager = $Head/WeaponManager

onready var player_collider = get_node(collider)
onready var jump = player_stats.jumpPower
onready var speed = player_stats.default_speed

var input_vec = Vector2()
var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

var is_shooting = false
var is_zoomed = false
var is_crouching = false
var is_sprinting = false
var is_jumping = false
var is_upright = true
var is_thirdPerson = false
var is_idle = false


#States
var moving_left = false
var moving_right = false
var moving_forward = false
var moving_backward = false
var jumping = false

#Debug
var moving = false
var shouldMove = true
var canJump = true
var coords
var is_holding_rifle = false
var is_holding_pistol = false
var is_holding_knife = false

var curr_fov
var look_col


func _ready():
	binoc.visible = false
	ui.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera1.make_current()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * player_stats.mouse_sense)) 
		head.rotate_x(deg2rad(-event.relative.y * player_stats.mouse_sense)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	look_col = look.get_collider()
	
	_ui_update()
	_handle_input(delta)
	_handle_gravity(delta)
	_handle_movement(delta)
	_handle_animation()
	
	coords = self.get_translation()


# animation States
func _handle_animation():
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

# gravity gets its own function
func _handle_gravity(delta):
	if !is_on_floor():
		fall.y -= player_stats.grav
		canJump = false
	else:
		canJump = true

# Input functions should be placed here
func _handle_input(delta):

	# Weapon Inputs
	if Input.is_action_just_pressed('Pickup'):
		if look.is_colliding():
			if look_col.is_in_group('Weapon'):
				wepManager.add_child(look_col.duplicate())
				wepManager.Pickup_Weapon()
				look_col.queue_free()
			elif look_col.is_in_group('Attachment'):
				wepManager.Pickup_Attachment()
			else:
				print('Not Weapon or Attachment')

	if Input.is_action_just_pressed('Reload'):
		wepManager.Reload()
	
	if Input.is_action_just_pressed('Drop'):
		wepManager.Drop_Weapon()

	if Input.is_action_just_pressed('Swap'):
		wepManager.Swap_Weapon()

	if Input.is_action_just_pressed('SwapMode'):
		wepManager.Swap_Mode()

	wepManager.Shoot(Input.is_action_just_pressed('Fire'), Input.is_action_pressed('Fire'))

	# Movement Inputs
	if Input.is_action_pressed('sprint'):
		speed = player_stats.sprint_speed
	
	if Input.is_action_pressed("crouch"):
		is_crouching = true
	else:
		is_crouching = false
	
	if Input.is_action_just_pressed("jump") && canJump:
		fall.y = jump
		is_jumping = true
	else:
		is_jumping = false

	input_vec.y = Input.get_action_strength('move_backward') - Input.get_action_strength('move_forward')
	input_vec.x = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	input_vec = input_vec.normalized().rotated(-rotation.y)


	# Utility Inputs
	if Input.is_action_pressed("zoom"):
		is_zoomed = true
	else:
		is_zoomed = false


	# Debug Inputs
	if Input.is_action_pressed("debug"):
		ui.visible = true
	else:
		ui.visible = false
	
	if Input.is_action_pressed("cam"):
		camera2.make_current()
	else:
		camera1.clear_current()
		camera1.make_current()

# get direction and apply movement
func _handle_movement(delta):
	
	if is_jumping:
		fall.y = jump

	if is_crouching:
		player_collider.shape.height -= player_stats.crouch_transition * delta
		speed = player_stats.crouch_speed
		jump = player_stats.crouchJump
	elif !is_crouching:
		player_collider.shape.height += player_stats.crouch_transition * delta
		speed = player_stats.default_speed
		jump = player_stats.regularJump
	player_collider.shape.height = clamp(player_collider.shape.height, player_stats.crouch_height, player_stats.default_height)
	

	if is_zoomed:
		crosshair.visible = false
		camera1.set_fov(lerp(camera1.get_fov(), player_stats.fov_zoom, player_stats.fov_trans * delta))
		binoc.visible = true
	else:
		crosshair.visible = true
		camera1.set_fov(lerp(camera1.get_fov(), player_stats.fov_base, player_stats.fov_trans * delta))
		binoc.visible = false


	direction.z = input_vec.y
	direction.x = input_vec.x

	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, player_stats.accel * delta) 
	velocity = move_and_slide(velocity, Vector3.UP)
	move_and_slide(fall, Vector3.UP)

# update ui?
func _ui_update():
	ui.lookcollide(look)
	ui.ismoving(moving)
	ui.isidle(is_idle)
	ui.floorcheck(ground)
	ui.updatecoords(coords)

#func _on_Area_area_entered(area):
#	fall.y = jump
