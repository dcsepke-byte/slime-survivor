extends CharacterBody2D
class_name Player

const SPEED := 200.0
const DASH_SPEED := 500.0

var dash_timer: float = 0.0
var dash_cooldown: float = 0.0
var dash_dir := Vector2.ZERO

var mobile: Node = null


func _ready() -> void:
	add_to_group("player")


func setup_mobile(ui: Node) -> void:
	mobile = ui


func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO
	if mobile:
		input = mobile.get_movement()
	# Auch Tastatur
	var kb := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if kb != Vector2.ZERO:
		input = kb
	
	if dash_timer > 0:
		dash_timer -= delta
		velocity = dash_dir * DASH_SPEED
	else:
		velocity = input * SPEED
		dash_cooldown = max(0.0, dash_cooldown - delta)
	
	move_and_slide()
	
	# Dash
	var want_dash := Input.is_key_pressed(KEY_SHIFT) or (mobile and mobile.pop_dash())
	if want_dash and dash_cooldown <= 0 and input != Vector2.ZERO:
		dash_timer = 0.15
		dash_cooldown = 0.8
		dash_dir = input.normalized()
	
	# Feuern
	var want_fire := Input.is_key_pressed(KEY_SPACE) or (mobile and mobile.pop_fire())
	if want_fire:
		_cast_fireball()


func _cast_fireball() -> void:
	var fb: Area2D = preload("res://scenes/fireball.tscn").instantiate()
	fb.position = global_position + Vector2(20, 0)
	
	var dir := Vector2.RIGHT
	if mobile:
		var mov := mobile.get_movement()
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
