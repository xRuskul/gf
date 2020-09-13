extends RigidBody
class_name Weapon

export(Resource) onready var stats

export(PackedScene) var Bullet
export(NodePath) var Muzzle

onready var muzzle = get_node(Muzzle)
onready var bullet = Bullet


export var magSize := 25
export var ammoCount := 25
var shotTimer = null
var reloadTimer = null

enum weaponState{
	IDLE,
	AIMING,
	FIRING,
	RELOADING
}

var wepStatus = weaponState.IDLE

func _ready() -> void:
	_shotTimer()
	_reloadTimer()

func on_timeout_complete():
	stats.canFire = true
	stats.canReload = true

func _shotTimer() -> void:
	shotTimer = Timer.new()
	shotTimer.set_one_shot(true)
	shotTimer.set_wait_time(stats.FireRate)
	shotTimer.connect('timeout', self, 'on_timeout_complete')
	add_child(shotTimer)

func _reloadTimer() -> void:
	reloadTimer = Timer.new()
	reloadTimer.set_one_shot(true)
	#reloadTimer.set_wait_time(stats.reloadTime)
	reloadTimer.connect('timeout', self, 'on_timeout_complete')
	add_child(reloadTimer)

func _shoot(FIP: bool, FIH: bool):
	if !stats.canFire:
		return
	
	if stats.FireMode == stats.FireModeOne && !FIP:
		return
	if stats.FireMode == stats.FireModeTwo && !FIH:
		return

	if ammoCount != 0 && stats.canFire:
		ammoCount -= 1
		print('Shots Left', ' ',ammoCount)
		var b = bullet.instance()
		muzzle.add_child(b)
		b.shot = true
		wepStatus = weaponState.FIRING
		stats.canFire = false
		shotTimer.start()
	else:
		wepStatus = weaponState.IDLE

func _swap_mode():
	if stats.FireMode == stats.FireModeOne:
		stats.FireMode = stats.FireModeTwo
	elif stats.FireMode == stats.FireModeTwo:
		stats.FireMode = stats.FireModeOne


func _reload():
	if ammoCount < magSize && ammoCount > 0 && stats.canReload && stats.canFire:
		ammoCount = magSize
		stats.canReload = false
		stats.canFire = false
		reloadTimer.set_wait_time(stats.reloadTime)
		reloadTimer.start()
	elif ammoCount <= 0 && stats.canReload && stats.canFire:
		ammoCount = magSize
		stats.canReload = false
		stats.canFire = false
		reloadTimer.set_wait_time(stats.reloadFromEmpty)
		reloadTimer.start()
