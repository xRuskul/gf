extends RigidBody

var shoot = false

const DAMAGE = 50
const SPEED = 25

func _ready() -> void:
	set_as_toplevel(true)

func _physics_process(delta: float) -> void:
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)


func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group('Enemy'):
		body.health -= DAMAGE
		queue_free()
	else:
		queue_free()
