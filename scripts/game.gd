extends Node2D

func _ready() -> void:
	var mobile_ui: Node = preload("res://scenes/mobile_ui.tscn").instantiate()
	add_child(mobile_ui)
	
	var player: Player = $Player
	player.setup_mobile(mobile_ui)
	
	var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
	var positions: Array[Vector2] = [Vector2(200, 150), Vector2(400, 150), Vector2(300, 250)]
	for pos in positions:
		var e: Enemy = enemy_scene.instantiate()
		e.position = pos
		add_child(e)
