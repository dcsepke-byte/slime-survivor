extends Area2D
## Feuerball — bewegt sich, trifft Gegner & Spieler

const SPEED := 400.0
const LIFETIME := 2.0

var direction: Vector2 = Vector2.RIGHT
var _life: float = 0.0


func _ready() -> void:
	# Sichtbarer Kreis
	var sprite := Sprite2D.new()
	var img := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	img.fill(Color(1, 0.3, 0, 0.8))
	for x in range(4, 12):
		for y in range(4, 12):
			img.set_pixel(x, y, Color(1, 0.8, 0, 1))
	for x in range(6, 10):
		for y in range(6, 10):
			img.set_pixel(x, y, Color(1, 1, 0.5, 1))
	sprite.texture = ImageTexture.create_from_image(img)
	sprite.scale = Vector2(2, 2)
	add_child(sprite)
	
	# Kollision
	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 12.0
	col.shape = shape
	add_child(col)
	
	# ⚠️ DAS war der Bug: Signal nie verbunden!
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta
	_life += delta
	modulate.a = 1.0 - (_life / LIFETIME)
	if _life > LIFETIME:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()
