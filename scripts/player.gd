extends CharacterBody2D
class_name Player

const SPEED := 200.0
const FIRE_RATE := 0.3
const MAX_HP := 5

var hp := MAX_HP
var mobile: Node = null
var fire_cooldown: float = 0.0

# XP & Level
var xp: int = 0
var level: int = 1
var xp_to_next: int = 10
var damage_bonus: int = 0


func _ready() -> void:
	add_to_group("player")


func setup_mobile(ui: Node) -> void:
	mobile = ui


func _physics_process(delta: float) -> void:
	var input: Vector2 = Vector2.ZERO
	if mobile:
		input = mobile.get_movement()
	var kb: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if kb != Vector2.ZERO:
		input = kb
	velocity = input * SPEED
	move_and_slide()
	
	fire_cooldown = max(0.0, fire_cooldown - delta)
	var want_fire: bool = Input.is_key_pressed(KEY_SPACE)
	if mobile and mobile.is_firing() and fire_cooldown <= 0:
		want_fire = true
	
	if want_fire and fire_cooldown <= 0:
		fire_cooldown = FIRE_RATE
		_cast_fireball()
	
	var bar: ColorRect = get_node_or_null("HPBar")
	if bar:
		bar.size.x = 40.0 * hp / MAX_HP


func _cast_fireball() -> void:
	var fb: Area2D = preload("res://scenes/fireball.tscn").instantiate()
	fb.position = global_position
	var dir: Vector2 = Vector2.RIGHT
	if mobile:
		var aim: Vector2 = mobile.get_aim()
		if aim != Vector2.ZERO:
			dir = aim
		else:
			var mov: Vector2 = mobile.get_movement()
			if mov != Vector2.ZERO:
				dir = mov
	else:
		var md: Vector2 = get_global_mouse_position() - global_position
		if md != Vector2.ZERO:
			dir = md
	fb.set("direction", dir.normalized() if dir != Vector2.ZERO else Vector2.RIGHT)
	get_parent().add_child(fb)


func take_damage(_amount: int) -> void:
	hp -= 1
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if hp <= 0:
		queue_free()


func add_xp(amount: int) -> void:
	xp += amount
	if xp >= xp_to_next:
		_level_up()


func _level_up() -> void:
	level += 1
	xp -= xp_to_next
	xp_to_next = int(xp_to_next * 1.5)
	damage_bonus += 1
	# Flash
	modulate = Color.GOLD
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE
