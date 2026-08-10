extends Area2D
## Fireball projectile — flies in direction, damages enemies, self-damage possible

const SPEED := 400.0
const LIFETIME := 2.0

var direction := Vector2.RIGHT
var _life := 0.0


func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta
	_life += delta
	if _life > LIFETIME:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(1)
		queue_free()
	elif body.is_in_group("player"):
		body.take_damage(1)  # Selbstschaden!
		queue_free()
