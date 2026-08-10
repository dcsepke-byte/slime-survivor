extends CanvasLayer
## Mobile Touch-Steuerung mit Multi-Touch und Screen-Zonen

var joystick_id := -1
var joystick_center := Vector2.ZERO
var movement := Vector2.ZERO

var fire_queued := false
var dash_queued := false

@onready var knob: ColorRect = $Knob
@onready var bg: ColorRect = $Bg


func _ready() -> void:
	bg.visible = false
	knob.visible = false


func _input(event: InputEvent) -> void:
	var vs := get_viewport().get_visible_rect().size
	var half := vs.x * 0.5
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < half:
				# Joystick starten
				joystick_id = event.index
				joystick_center = event.position
				bg.position = joystick_center - Vector2(80, 80)
				bg.visible = true
				knob.position = joystick_center - Vector2(25, 25)
				knob.visible = true
			else:
				# Aktion: rechts oben = Feuer, rechts unten = Dash
				if event.position.y < vs.y * 0.5:
					fire_queued = true
				else:
					dash_queued = true
		else:
			if event.index == joystick_id:
				joystick_id = -1
				bg.visible = false
				knob.visible = false
				movement = Vector2.ZERO
	
	elif event is InputEventScreenDrag and event.index == joystick_id:
		var offset: Vector2 = event.position - joystick_center
		if offset.length() > 80:
			offset = offset.normalized() * 80
		knob.position = joystick_center + offset - Vector2(25, 25)
		movement = offset / 80.0


func get_movement() -> Vector2:
	return movement
	
func pop_fire() -> bool:
	if fire_queued:
		fire_queued = false
		return true
	return false
	
func pop_dash() -> bool:
	if dash_queued:
		dash_queued = false
		return true
	return false
