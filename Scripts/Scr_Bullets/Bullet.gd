extends RigidBody

var shot = false

var DAMAGE
var SPEED
var despawnTimer
var countRate = 1.0

func _ready() -> void:
	_despawnTimer()
	set_as_toplevel(true)
	DAMAGE = get_parent().get_parent().get_parent().stats.Damage
	SPEED = get_parent().get_parent().get_parent().stats.MuzzleVelocity
	despawnTimer.start()

func _despawnTimer() -> void:
	despawnTimer = Timer.new()
	despawnTimer.set_one_shot(true)
	despawnTimer.set_wait_time(countRate)
	despawnTimer.connect('timeout', self, 'queue_free')
	add_child(despawnTimer)

func _physics_process(delta: float) -> void:
	if shot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED * delta) 

func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group('Enemy'):
		body.health -= DAMAGE
		queue_free()
	else:
		queue_free()
