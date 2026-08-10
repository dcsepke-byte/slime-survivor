extends CanvasLayer
## Mobile Touch Controls — Joystick + Buttons

var joystick_active := false
var joystick_center := Vector2.ZERO
var joystick_pos := Vector2.ZERO
var joystick_radius := 80.0
var movement_vector := Vector2.ZERO

@onready var joystick_bg: ColorRect = $JoystickBG
@onready var joystick_knob: ColorRect = $JoystickBG/Knob
@onready var btn_fire: Button = $FireButton
@onready var btn_dash: Button = $DashButton

signal fire_pressed
signal dash_pressed


func _ready() -> void:
	joystick_bg.visible = false
	btn_fire.pressed.connect(func(): fire_pressed.emit())
	btn_dash.pressed.connect(func(): dash_pressed.emit())


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# Linke Bildhälfte = Joystick
			if event.position.x < get_viewport().size.x * 0.5:
				joystick_active = true
				joystick_center = event.position
				joystick_pos = event.position
				joystick_bg.position = joystick_center - Vector2(joystick_radius, joystick_radius)
				joystick_bg.visible = true
				_update_joystick(event.position)
		else:
			if joystick_active:
				joystick_active = false
				joystick_bg.visible = false
				movement_vector = Vector2.ZERO
				joystick_knob.position = Vector2(joystick_radius, joystick_radius)
	elif event is InputEventScreenDrag and joystick_active:
		_update_joystick(event.position)


func _update_joystick(pos: Vector2) -> void:
	var offset := pos - joystick_center
	var dist := offset.length()
	if dist > joystick_radius:
		offset = offset.normalized() * joystick_radius
	joystick_knob.position = offset + Vector2(joystick_radius, joystick_radius)
	movement_vector = offset / joystick_radius


func get_movement() -> Vector2:
	return movement_vector
