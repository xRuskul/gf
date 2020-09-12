extends Control

onready var fpslabel = get_node("FPS")
onready var speedlabel = get_node("Speed")
onready var movinglabel = get_node("IsMoving")
onready var idlelable = get_node("IsIdle")
onready var floorcheck = get_node("FloorCheck")
onready var frontray = get_node("Look")


func _ready():
	pass

func lookcollide(iscollide):
	frontray.text = "Looking_Colliding: " + str(iscollide)

func updatecoords(cords):
	speedlabel.text= "Translation: " + str(cords)

func isidle(is_idle):
	idlelable.text = "Is_Idle: " + str(is_idle)

func ismoving(moving):
	movinglabel.text = "Is_Moving: " + str(moving)

func floorcheck(cfloor):
	floorcheck.text = "Is_On_Floor: " + str(cfloor)

func _physics_process(delta):
	fpslabel.text = "FPS: " + str(Engine.get_frames_per_second())
