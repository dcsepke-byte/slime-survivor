extends CanvasLayer

var joystick_active := false
var joystick_center := Vector2.ZERO
var joystick_radius := 80.0
var movement_vector := Vector2.ZERO
var last_touch_id := -1

@onready var joystick_bg: ColorRect = $JoystickBG
@onready var joystick_knob: ColorRect = $JoystickBG/Knob

signal fire_pressed
signal dash_pressed


func _ready() -> void:
	joystick_bg.visible = false


func _input(event: InputEvent) -> void:
	var vs: Vector2 = get_viewport().get_visible_rect().size
	var mid_x := vs.x * 0.5
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < mid_x:
				# LINKE Zone = Joystick — merke Touch-ID für Multi-Touch
				joystick_active = true
				last_touch_id = event.index
				joystick_center = event.position
				joystick_bg.position = joystick_center - Vector2(joystick_radius, joystick_radius)
				joystick_bg.visible = true
				_update_joystick(event.position)
			else:
				# RECHTE Zone = Aktionen (eigener Touch, stört Joystick nicht)
				if event.position.y < vs.y * 0.5:
					fire_pressed.emit()
				else:
					dash_pressed.emit()
		else:
			# Loslassen — nur wenn ES der Joystick-Touch war
			if event.index == last_touch_id:
				joystick_active = false
				joystick_bg.visible = false
				movement_vector = Vector2.ZERO
				joystick_knob.position = Vector2(joystick_radius, joystick_radius)
				last_touch_id = -1
	
	elif event is InputEventScreenDrag and joystick_active and event.index == last_touch_id:
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
