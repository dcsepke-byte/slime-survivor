extends CharacterBody2D
class_name Player

const SPEED := 200.0
const DASH_SPEED := 500.0

var dash_active := false
var dash_timer: float = 0.0
var dash_cooldown: float = 0.0
var dash_dir := Vector2.ZERO

var mobile_ui: Node = null
var fire_queued := false
var dash_queued := false


func _ready() -> void:
	add_to_group("player")


func setup_mobile_ui(ui: Node) -> void:
	mobile_ui = ui
	ui.fire_pressed.connect(func(): fire_queued = true)
	ui.dash_pressed.connect(func(): dash_queued = true)


func _physics_process(delta: float) -> void:
	# Movement: Touch-Joystick oder Tastatur
	var input := Vector2.ZERO
	if mobile_ui:
		input = mobile_ui.get_movement()
	# Auch Tastatur-Eingabe zulassen (für Desktop-Test)
	var kb := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if kb != Vector2.ZERO:
		input = kb
	
	if dash_active:
		dash_timer -= delta
		if dash_timer <= 0:
			dash_active = false
		velocity = dash_dir * DASH_SPEED
	else:
		velocity = input * SPEED
		dash_cooldown = max(0.0, dash_cooldown - delta)
	
	move_and_slide()
	
	# Dash (Shift oder Mobile-Button)
	if (Input.is_key_pressed(KEY_SHIFT) or dash_queued) and dash_cooldown <= 0 and input != Vector2.ZERO:
		dash_active = true
		dash_timer = 0.15
		dash_cooldown = 0.8
		dash_dir = input.normalized()
		dash_queued = false
	
	# Fire (Space oder Mobile-Button)
	if Input.is_key_pressed(KEY_SPACE) or fire_queued:
		_cast_fireball()
		fire_queued = false


func _cast_fireball() -> void:
	var fb: Area2D = preload("res://scenes/fireball.tscn").instantiate()
	fb.position = global_position + Vector2(20, 0)
	
	# Richtung: Maus (Desktop) oder Bewegungsrichtung (Mobile)
	var dir: Vector2
	if mobile_ui and mobile_ui.get_movement() != Vector2.ZERO:
		dir = mobile_ui.get_movement().normalized()
	else:
		dir = (get_global_mouse_position() - global_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	fb.set("direction", dir)
	get_parent().add_child(fb)


func take_damage(_amount: int) -> void:
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
