extends Area2D
class_name XPOrb
## XP-Orb — fliegt zum Spieler, gibt XP

var xp_value: int = 1
var target: Node2D = null
var speed: float = 200.0

func _ready() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]
	
	var sprite := Sprite2D.new()
	# Kleiner grüner Kreis
	var img := Image.create(8, 8, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 1, 0.5, 0.9))
	sprite.texture = ImageTexture.create_from_image(img)
	sprite.scale = Vector2(2, 2)
	add_child(sprite)
	
	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 8.0
	col.shape = shape
	add_child(col)
	
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if not target:
		queue_free()
		return
	
	var dir: Vector2 = global_position.direction_to(target.global_position)
	var dist: float = global_position.distance_to(target.global_position)
	
	if dist < 8:
		_collect()
	else:
		# Magnet-Effekt: schneller je näher
		var spd: float = speed + (100.0 / max(dist, 1.0))
		position += dir * spd * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_collect()


func _collect() -> void:
	if target and target.has_method("add_xp"):
		target.add_xp(xp_value)
	queue_free()
