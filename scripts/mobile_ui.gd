extends CanvasLayer
## Mobile Touch-Steuerung — simpel & robust

var active := false
var start_pos := Vector2.ZERO
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
				active = true
				start_pos = event.position
				bg.position = start_pos - Vector2(80, 80)
				knob.position = start_pos - Vector2(25, 25)
				bg.visible = true
				knob.visible = true
			else:
				if event.position.y < vs.y * 0.5:
					fire_queued = true
				else:
					dash_queued = true
		else:
			# JEDES Loslassen auf linker Seite deaktiviert
			if event.position.x < half:
				active = false
				bg.visible = false
				knob.visible = false
				movement = Vector2.ZERO
	
	elif event is InputEventScreenDrag:
		if active:
			var off: Vector2 = event.position - start_pos
			if off.length() > 80:
				off = off.normalized() * 80
			knob.position = start_pos + off - Vector2(25, 25)
			movement = off / 80.0


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
