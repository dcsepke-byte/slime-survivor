extends CharacterBody2D
class_name Player

const SPEED := 200.0
const DASH_SPEED := 500.0
const DASH_DURATION := 0.15
const DASH_COOLDOWN := 0.8

var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_dir := Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var spell_spawn: Marker2D = $SpellSpawn


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if dash_timer > 0.0:
		dash_timer -= delta
		velocity = dash_dir * DASH_SPEED
	else:
		velocity = input * SPEED
		dash_cooldown_timer = max(0.0, dash_cooldown_timer - delta)
		
		if Input.is_key_pressed(KEY_SHIFT) and dash_cooldown_timer <= 0.0 and input != Vector2.ZERO:
			dash_timer = DASH_DURATION
			dash_cooldown_timer = DASH_COOLDOWN
			dash_dir = input.normalized()
	
	move_and_slide()
	
	if Input.is_key_pressed(KEY_SPACE):
		_cast_fireball()


func _cast_fireball() -> void:
	var fb_scene: PackedScene = preload("res://scenes/fireball.tscn")
	var fb: Area2D = fb_scene.instantiate()
	fb.position = spell_spawn.global_position
	var mouse_pos := get_global_mouse_position()
	var dir: Vector2 = (mouse_pos - global_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	fb.set("direction", dir)
	get_parent().add_child(fb)


func take_damage(_amount: int) -> void:
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
