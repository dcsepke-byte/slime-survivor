extends CanvasLayer
## Dev Mode — Cheats, Debug-Overlay, Spawning, God Mode
## Aktivierung: URL ?dev=1 oder F1-Taste

var enabled := false
var god_mode := false
var show_hitboxes := false
var console_visible := false
var console_input := ""

@onready var overlay: Label = $Overlay


func _ready() -> void:
	# Aktivieren via URL-Parameter (Web)
	var args := OS.get_cmdline_args()
	if "?dev=1" in str(args) or "--dev" in args:
		enabled = true
	overlay.visible = enabled
	layer = 200  # Über allen anderen UI-Layern


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_F1: _toggle()
			KEY_F2: _god_mode()
			KEY_F3: _spawn_enemy()
			KEY_F4: _kill_all()
			KEY_F5: _give_item()
			KEY_F7: _toggle_hitboxes()
			KEY_F10: _toggle_overlay()
			KEY_QUOTELEFT: _toggle_console()
	
	if console_visible and event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER:
				_execute(console_input)
				console_input = ""
			KEY_BACKSPACE:
				console_input = console_input.left(-1)
			_:
				if event.unicode >= 32:
					console_input += char(event.unicode)


func _process(_delta: float) -> void:
	if not enabled or not overlay.visible:
		return
	
	var stats: String = ""
	var player: Player = get_tree().get_first_node_in_group("player")
	if player:
		stats += "HP: %d  " % player.hp
		if player.has_method("get_weapon"):
			stats += "Waffe: %s  " % player.get_weapon()
	
	var enemies := get_tree().get_nodes_in_group("enemy")
	var room: String = "?"
	
	var text := "DEV MODE | FPS: %d | Gegner: %d | %s" % [Engine.get_frames_per_second(), enemies.size(), stats]
	if console_visible:
		text += "\n> " + console_input
	overlay.text = text


func _toggle() -> void:
	enabled = !enabled
	overlay.visible = enabled


func _god_mode() -> void:
	god_mode = !god_mode
	print("God Mode: ", god_mode)


func _spawn_enemy() -> void:
	var p := get_tree().get_first_node_in_group("player")
	if not p: return
	var e: Enemy = preload("res://scenes/enemy.tscn").instantiate()
	e.position = p.position + Vector2(randi_range(-50,50), randi_range(-50,50))
	get_tree().current_scene.add_child(e)
	e.setup("slime_green")
	print("Gespawned: slime_green at ", e.position)


func _kill_all() -> void:
	for e in get_tree().get_nodes_in_group("enemy"):
		e.queue_free()
	print("Alle Gegner entfernt")


func _give_item() -> void:
	print("Item: fire_wand gegeben (Dev)")


func _toggle_hitboxes() -> void:
	show_hitboxes = !show_hitboxes
	for c in get_tree().get_nodes_in_group("enemy"):
		if c.has_node("CollisionShape2D"):
			c.get_node("CollisionShape2D").visible = show_hitboxes
	print("Hitboxes: ", show_hitboxes)


func _toggle_overlay() -> void:
	overlay.visible = !overlay.visible


func _toggle_console() -> void:
	console_visible = !console_visible
	console_input = ""


func _execute(cmd: String) -> void:
	match cmd:
		"god": _god_mode()
		"killall": _kill_all()
		"spawn": _spawn_enemy()
		"heal":
			var p := get_tree().get_first_node_in_group("player")
			if p: p.hp = p.MAX_HP
		_:
			print("Dev: Unbekannter Befehl: ", cmd)
