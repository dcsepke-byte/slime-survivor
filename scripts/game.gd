extends Node2D
## Slime Survivor — Datengetriebener Level-Manager

var current_room := -1
var total_kills := 0

@onready var player: Player = $Player


func _ready() -> void:
	var mobile_ui: Node = preload("res://scenes/mobile_ui.tscn").instantiate()
	add_child(mobile_ui)
	player.setup_mobile(mobile_ui)
	
	_enter_room("start_cell")
	_create_hud()


func _enter_room(room_id: String) -> void:
	# Clear
	for n in get_tree().get_nodes_in_group("enemy"):
		n.queue_free()
	for n in get_tree().get_nodes_in_group("door"):
		n.queue_free()
	
	# Load room data
	var json_str := FileAccess.get_file_as_string("res://assets/rooms.json")
	var rooms: Array = JSON.parse_string(json_str)
	var room: Dictionary = {}
	for r in rooms:
		if r["id"] == room_id:
			room = r
			break
	if room.is_empty():
		return
	
	current_room += 1
	var size: Array = room["size"]
	var w: float = size[0] * 16
	var h: float = size[1] * 16
	
	# Wände
	_build_walls(Vector2(60, 40), w, h)
	
	# Player in Mitte
	player.position = Vector2(60 + w/2, 40 + h/2)
	
	# Türen
	if room_id != "boss_room":
		_create_door(Vector2(60 + w - 16, 40 + h/2), "combat_medium")
	
	# Enemies spawnen
	var budget: int = room.get("enemy_budget", 0)
	var pool: Array = _get_enemy_pool(room.get("difficulty", 1))
	while budget > 0 and pool.size() > 0:
		var eid: String = pool[randi() % pool.size()]
		var e: Enemy = preload("res://scenes/enemy.tscn").instantiate()
		# Zufällige Position im Raum
		e.position = Vector2(
			randi_range(int(60 + 20), int(60 + w - 20)),
			randi_range(int(40 + 20), int(40 + h - 20))
		)
		add_child(e)
		e.setup(eid)
		budget -= e.e_hp
	
	_update_hud()


func _get_enemy_pool(difficulty: int) -> Array[String]:
	match difficulty:
		0: return ["slime_green"]
		1: return ["slime_green", "slime_green", "bat"]
		2: return ["slime_green", "slime_red", "bat", "skeleton_archer"]
		3: return ["slime_red", "skeleton_archer", "wraith", "exploder_slime"]
		_: return ["slime_red", "wraith", "exploder_slime", "boss_slime_king"]


func _build_walls(pos: Vector2, w: float, h: float) -> void:
	var c := Color(0.25, 0.22, 0.2)
	# Links, rechts
	for p in [Vector2(pos.x, pos.y), Vector2(pos.x + w, pos.y)]:
		var wall := ColorRect.new()
		wall.position = p
		wall.size = Vector2(8, h)
		wall.color = c
		add_child(wall)
	# Oben, unten
	for p in [Vector2(pos.x, pos.y), Vector2(pos.x, pos.y + h)]:
		var wall := ColorRect.new()
		wall.position = p
		wall.size = Vector2(w + 8, 8)
		wall.color = c
		add_child(wall)


func _create_door(pos: Vector2, target: String) -> void:
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
			_enter_room(target)
	)
	add_child(door)
	var rect := ColorRect.new()
	rect.position = pos - Vector2(12, 24)
	rect.size = Vector2(24, 48)
	rect.color = Color(0.5, 0.8, 0.3, 0.6)
	add_child(rect)


func _create_hud() -> void:
	var hud := Label.new()
	hud.name = "HUD"
	hud.position = Vector2(8, 4)
	hud.add_theme_color_override("font_color", Color.WHITE)
	hud.add_theme_font_size_override("font_size", 14)
	add_child(hud)


func _update_hud() -> void:
	if has_node("HUD"):
		$HUD.text = "Room %d  |  Kills: %d" % [current_room + 1, total_kills]
