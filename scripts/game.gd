extends Node2D
## Slime Survivor — Level Manager mit Room-Progression

var current_room := 0
var rooms_cleared := 0

@onready var player: Player = $Player

func _ready() -> void:
	var mobile_ui: Node = preload("res://scenes/mobile_ui.tscn").instantiate()
	add_child(mobile_ui)
	player.setup_mobile(mobile_ui)
	
	_spawn_room(0)
	_update_hud()


func _spawn_room(room_id: int) -> void:
	# Alte Gegner + Türen löschen
	for n in get_tree().get_nodes_in_group("enemy"):
		n.queue_free()
	for n in get_tree().get_nodes_in_group("door"):
		n.queue_free()
	
	current_room = room_id
	
	# Raum-Definitionen
	match room_id:
		0: # Startraum — einfach
			_build_walls(Vector2(100, 80), 440, 280)
			player.position = Vector2(320, 200)
			_spawn_enemy(Vector2(200, 150))
			_spawn_enemy(Vector2(400, 200))
			_create_door(Vector2(540, 180), 1)
		1: # Zweiter Raum — schwerer
			_build_walls(Vector2(100, 80), 440, 280)
			player.position = Vector2(130, 200)
			_spawn_enemy(Vector2(250, 140))
			_spawn_enemy(Vector2(350, 200))
			_spawn_enemy(Vector2(200, 260))
			_create_door(Vector2(540, 180), 2)
		2: # Boss-Raum
			_build_walls(Vector2(100, 80), 440, 280)
			player.position = Vector2(130, 200)
			var boss: Enemy = _spawn_enemy(Vector2(350, 180))
			boss.hp = 8
			boss.max_hp = 8
			boss.modulate = Color.RED
			boss.scale = Vector2(2, 2)
			boss.update_hp_bar()
	
	_update_hud()


func _build_walls(pos: Vector2, w: float, h: float) -> void:
	var wall := ColorRect.new()
	wall.color = Color(0.25, 0.22, 0.2)  # Dunkle Steinmauer
	wall.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Links
	_lw(pos, Vector2(8, h))
	# Rechts
	_lw(Vector2(pos.x + w - 8, pos.y), Vector2(8, h))
	# Oben
	_lw(pos, Vector2(w, 8))
	# Unten
	_lw(Vector2(pos.x, pos.y + h - 8), Vector2(w, 8))


func _lw(p: Vector2, s: Vector2) -> void:
	var w := ColorRect.new()
	w.position = p
	w.size = s
	w.color = Color(0.25, 0.22, 0.2)
	w.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(w)


func _spawn_enemy(pos: Vector2) -> Enemy:
	var e: Enemy = preload("res://scenes/enemy.tscn").instantiate()
	e.position = pos
	add_child(e)
	e.tree_exiting.connect(func(): _on_enemy_died())
	return e


func _create_door(pos: Vector2, target: int) -> void:
	var door := Area2D.new()
	door.position = pos
	door.add_to_group("door")
	var col := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(24, 48)
	col.shape = shape
	door.add_child(col)
	door.body_entered.connect(func(b: Node2D):
		if b == player:
			_spawn_room(target)
	)
	add_child(door)
	# Tür-Visual
	var rect := ColorRect.new()
	rect.position = pos - Vector2(12, 24)
	rect.size = Vector2(24, 48)
	rect.color = Color(0.5, 0.8, 0.3, 0.6)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(rect)


func _on_enemy_died() -> void:
	rooms_cleared += 1
	_update_hud()


func _update_hud() -> void:
	# Einfaches HUD
	if not has_node("HUD"):
		var hud := Label.new()
		hud.name = "HUD"
		hud.position = Vector2(8, 4)
		hud.add_theme_color_override("font_color", Color.WHITE)
		hud.add_theme_font_size_override("font_size", 16)
		add_child(hud)
	$HUD.text = "Room %d  |  Kills: %d  → Tür zum nächsten Raum" % [current_room + 1, rooms_cleared]
