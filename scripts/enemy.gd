extends CharacterBody2D
class_name Enemy
## Simple enemy — patrols, takes damage from fireballs

var hp := 3
var patrol_dir := 1.0
const SPEED := 60.0
var _timer := 0.0


func _ready() -> void:
	add_to_group("enemy")


func _physics_process(delta: float) -> void:
	_timer += delta
	if _timer > 2.0:
		_timer = 0.0
		patrol_dir *= -1.0
	velocity = Vector2(patrol_dir * SPEED, 0)
	move_and_slide()


func take_damage(amount: int) -> void:
	hp -= amount
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if hp <= 0:
		queue_free()
