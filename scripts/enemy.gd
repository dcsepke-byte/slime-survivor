extends CharacterBody2D
class_name Enemy
## Vampire-Survivors-Pattern: Verfolgt Spieler mit direction_to()

var hp: int = 3
var max_hp: int = 3
var player: Player = null
const SPEED := 80.0

@onready var hp_bar: ColorRect = $HPBar
@onready var hp_bg: ColorRect = $HPBg


func _ready() -> void:
	add_to_group("enemy")
	update_hp_bar()
	# Spieler finden
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]


func _physics_process(_delta: float) -> void:
	if player:
		# Vampire-Survivors-Chase: direction_to()
		var dir: Vector2 = global_position.direction_to(player.global_position)
		velocity = dir * SPEED
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
