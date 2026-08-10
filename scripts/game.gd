extends Node2D
## Slime Survivor — Main Game Scene (Level 1: Pilzwald)

func _ready() -> void:
	var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
	var positions: Array[Vector2] = [Vector2(200, 150), Vector2(400, 150), Vector2(300, 250)]
	for pos in positions:
		var e: Enemy = enemy_scene.instantiate()
		e.position = pos
		add_child(e)
