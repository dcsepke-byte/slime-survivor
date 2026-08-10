extends Resource
class_name StatusEffect
## Status-Effekt: Burn, Freeze, Poison etc.

@export var id: String = ""
@export var duration: float = 3.0
@export var value: float = 1.0
@export var tick_interval: float = 1.0
@export var color: Color = Color.WHITE

var time_left: float = 0.0
var tick_timer: float = 0.0


func apply(target: Node2D) -> void:
	time_left = duration
	tick_timer = tick_interval


func tick(delta: float, target: Node2D) -> bool:
	time_left -= delta
	tick_timer -= delta
	
	if tick_timer <= 0:
		tick_timer = tick_interval
		match id:
			"burn":
				if target.has_method("take_damage"):
					target.take_damage(int(value))
			"poison":
				if target.has_method("take_damage"):
					target.take_damage(int(value))
			"freeze":
				if target is CharacterBody2D:
					target.velocity = Vector2.ZERO
	
	return time_left <= 0  # true = abgelaufen
