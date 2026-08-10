extends CanvasLayer
## Dual-Stick Mobile-Steuerung
## Linker Stick = Bewegen | Rechter Stick = Zielen & Schießen

var left_active := false
var left_start := Vector2.ZERO
var movement := Vector2.ZERO

var right_active := false
var right_start := Vector2.ZERO
var aim_dir := Vector2.ZERO
var fire_held := false

var stick_radius := 80.0

@onready var knob_l: ColorRect = $KnobL
@onready var bg_l: ColorRect = $BgL
@onready var knob_r: ColorRect = $KnobR
@onready var bg_r: ColorRect = $BgR


func _ready() -> void:
	bg_l.visible = false
	knob_l.visible = false
	bg_r.visible = false
	knob_r.visible = false


func _input(event: InputEvent) -> void:
	var vs := get_viewport().get_visible_rect().size
	var half := vs.x * 0.5
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < half:
				# Linker Stick
				left_active = true
				left_start = event.position
				bg_l.position = left_start - Vector2(stick_radius, stick_radius)
				knob_l.position = left_start - Vector2(25, 25)
				bg_l.visible = true
				knob_l.visible = true
			else:
				# Rechter Stick = Zielen + Schießen
				right_active = true
				fire_held = true
				right_start = event.position
				bg_r.position = right_start - Vector2(stick_radius, stick_radius)
				knob_r.position = right_start - Vector2(25, 25)
				bg_r.visible = true
				knob_r.visible = true
		else:
			if event.position.x < half:
				left_active = false
				bg_l.visible = false
				knob_l.visible = false
				movement = Vector2.ZERO
			else:
				right_active = false
				fire_held = false
				bg_r.visible = false
				knob_r.visible = false
				aim_dir = Vector2.ZERO
	
	elif event is InputEventScreenDrag:
		if left_active and event.position.x < vs.x * 0.7:
			var off: Vector2 = event.position - left_start
			if off.length() > stick_radius:
				off = off.normalized() * stick_radius
			knob_l.position = left_start + off - Vector2(25, 25)
			movement = off / stick_radius
		
		elif right_active:
			var off: Vector2 = event.position - right_start
			if off.length() > stick_radius:
				off = off.normalized() * stick_radius
			knob_r.position = right_start + off - Vector2(25, 25)
			aim_dir = off / stick_radius


func get_movement() -> Vector2:
	return movement

func get_aim() -> Vector2:
	return aim_dir

func is_firing() -> bool:
	return fire_held and aim_dir != Vector2.ZERO
