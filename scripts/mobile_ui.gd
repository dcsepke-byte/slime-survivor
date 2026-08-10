extends CanvasLayer
## Mobile Screen-Zonen-Steuerung
## Linke Hälfte = Joystick-Zone | Rechte Hälfte = Aktionen-Zone

var joystick_active := false
var joystick_center := Vector2.ZERO
var joystick_radius := 80.0
var movement_vector := Vector2.ZERO

@onready var joystick_bg: ColorRect = $JoystickBG
@onready var joystick_knob: ColorRect = $JoystickBG/Knob
@onready var zone_fire: ColorRect = $ZoneFire
@onready var zone_dash: ColorRect = $ZoneDash

signal fire_pressed
signal dash_pressed


func _ready() -> void:
	joystick_bg.visible = false
	_resize_zones()


func _resize_zones() -> void:
	var vs: Vector2 = get_viewport().get_visible_rect().size
	zone_fire.size = Vector2(vs.x * 0.45, vs.y * 0.5)
	zone_fire.position = Vector2(vs.x * 0.55, 0)
	zone_dash.size = Vector2(vs.x * 0.45, vs.y * 0.5)
	zone_dash.position = Vector2(vs.x * 0.55, vs.y * 0.5)


func _input(event: InputEvent) -> void:
	var vs: Vector2 = get_viewport().get_visible_rect().size
	var mid_x := vs.x * 0.5
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < mid_x:
				# LINKE Zone = Joystick
				joystick_active = true
				joystick_center = event.position
				joystick_bg.position = joystick_center - Vector2(joystick_radius, joystick_radius)
				joystick_bg.visible = true
				_update_joystick(event.position)
			else:
				# RECHTE Zone = Aktionen
				if event.position.y < vs.y * 0.5:
					fire_pressed.emit()
				else:
					dash_pressed.emit()
		else:
			# Loslassen
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
