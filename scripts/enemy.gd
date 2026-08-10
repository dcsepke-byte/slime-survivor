extends CharacterBody2D
class_name Enemy
## Enemy with HP bar overhead

var hp: int = 3
var max_hp: int = hp
var patrol_dir: float = 1.0
var _timer: float = 0.0

const SPEED := 60.0

@onready var hp_bar: ColorRect = $HPBar
@onready var hp_bg: ColorRect = $HPBg


func _ready() -> void:
	add_to_group("enemy")
	update_hp_bar()


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
	update_hp_bar()
	if hp <= 0:
		queue_free()


func update_hp_bar() -> void:
	if hp_bar:
		hp_bar.size.x = 32.0 * hp / max_hp
	if hp_bg:
		hp_bg.position = Vector2(-16, -20)
	if hp_bar:
		hp_bar.position = Vector2(-16, -20)
