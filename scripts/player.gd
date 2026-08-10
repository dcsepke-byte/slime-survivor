extends CharacterBody2D
class_name Player
## Slime Survivor — Dual-Stick: Linker Stick = Bewegen, Rechter Stick = Zielen

const SPEED := 200.0
const FIRE_RATE := 0.3

var mobile: Node = null
var fire_cooldown: float = 0.0


func _ready() -> void:
	add_to_group("player")


func setup_mobile(ui: Node) -> void:
	mobile = ui


func _physics_process(delta: float) -> void:
	# Bewegung
	var input := Vector2.ZERO
	if mobile:
		input = mobile.get_movement()
	var kb := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if kb != Vector2.ZERO:
		input = kb
	velocity = input * SPEED
	move_and_slide()
	
	# Schießen: Rechter Stick oder Space (Desktop)
	fire_cooldown = max(0.0, fire_cooldown - delta)
	var want_fire: bool = Input.is_key_pressed(KEY_SPACE)
	if mobile and mobile.is_firing() and fire_cooldown <= 0:
		want_fire = true
	
	if want_fire and fire_cooldown <= 0:
		fire_cooldown = FIRE_RATE
		_cast_fireball()


func _cast_fireball() -> void:
	var fb: Area2D = preload("res://scenes/fireball.tscn").instantiate()
	fb.position = global_position
	
	# Richtung: Rechter Stick > Maus > Bewegungsrichtung
	var dir := Vector2.RIGHT
	if mobile:
		var aim: Vector2 = mobile.get_aim()
		if aim != Vector2.ZERO:
			dir = aim.normalized()
		else:
			var mov: Vector2 = mobile.get_movement()
			if mov != Vector2.ZERO:
				dir = mov.normalized()
	else:
		var md := get_global_mouse_position() - global_position
		if md != Vector2.ZERO:
			dir = md.normalized()
	
	fb.set("direction", dir)
	get_parent().add_child(fb)


func take_damage(_amount: int) -> void:
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
