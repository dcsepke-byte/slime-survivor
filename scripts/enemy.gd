extends CharacterBody2D
class_name Enemy
## Archetyp-basiertes Enemy-System

var data: Dictionary = {}
var e_hp: int = 3
var e_max_hp: int = 3
var e_damage: int = 1
var e_speed: float = 80.0
var e_archetype: String = "chaser"
var e_xp: int = 2

var player: Player = null
var contact_timer: float = 0.0
var shoot_timer: float = 0.0
var phase_timer: float = 0.0
var is_phased := false
var death_exploded := false

@onready var hp_bar: ColorRect = $HPBar
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	add_to_group("enemy")
	update_hp_bar()
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]


func setup(enemy_id: String) -> void:
	var json_str := FileAccess.get_file_as_string("res://assets/enemies.json")
	var enemies: Array = JSON.parse_string(json_str)
	for e in enemies:
		if e["id"] == enemy_id:
			data = e
			break
	if data.is_empty():
		return
	
	var s: Dictionary = data["stats"]
	e_hp = s["hp"]
	e_max_hp = s["hp"]
	e_damage = s["damage"]
	e_speed = s["speed"]
	e_archetype = data.get("archetype", "chaser")
	
	var v: Dictionary = data["visual"]
	if sprite and sprite.texture:
		sprite.region_enabled = true
		sprite.region_rect = Rect2(v.get("sprite_col", 0) * 16, v.get("sprite_row", 0) * 16, 
			v.get("size", 16), v.get("size", 16))
		sprite.scale = Vector2(v.get("scale", 2), v.get("scale", 2))
	
	var xp_range: Array = data["drops"]["xp"]
	e_xp = randi_range(xp_range[0], xp_range[1])


func _physics_process(delta: float) -> void:
	if not player:
		return
	
	var dist: float = global_position.distance_to(player.global_position)
	var dir: Vector2 = global_position.direction_to(player.global_position)
	var aggro: float = data.get("behavior", {}).get("aggro_range", 300)
	var atk_range: float = data.get("behavior", {}).get("attack_range", 16)
	var atk_cd: float = data.get("behavior", {}).get("attack_cooldown", 1.5)
	
	match e_archetype:
		"chaser", "tank":
			if dist < aggro:
				velocity = dir * e_speed
				move_and_slide()
		"swarm":
			if dist < aggro:
				velocity = dir * e_speed
				move_and_slide()
		"ranged":
			if dist < aggro and dist > data.get("behavior", {}).get("flee_range", 60):
				velocity = dir * e_speed * 0.5
				move_and_slide()
			elif dist < data.get("behavior", {}).get("flee_range", 60):
				velocity = -dir * e_speed
				move_and_slide()
			shoot_timer -= delta
			if shoot_timer <= 0 and dist < atk_range:
				_shoot_projectile(dir)
				shoot_timer = atk_cd
		"assassin":
			phase_timer -= delta
			if phase_timer <= 0:
				is_phased = not is_phased
				phase_timer = data.get("behavior", {}).get("phase_cooldown", 4.0)
				modulate.a = 0.3 if is_phased else 1.0
			if not is_phased and dist < aggro:
				velocity = dir * e_speed
				move_and_slide()
		"exploder":
			if dist < aggro:
				velocity = dir * e_speed * 1.3
				move_and_slide()
	
	# Kontakt-Schaden
	contact_timer -= delta
	if dist < 20 and contact_timer <= 0:
		var atk_data: Dictionary = data.get("stats", {}).duplicate()
		var def_data := {}
		var dmg: int = DamageCalculator.calculate(e_damage, atk_data, def_data, "physical")
		player.take_damage(dmg)
		contact_timer = 0.5


func _shoot_projectile(dir: Vector2) -> void:
	var p: Area2D = preload("res://scenes/fireball.tscn").instantiate()
	p.position = global_position
	p.set("direction", dir)
	get_parent().add_child(p)


func take_damage(amount: int) -> void:
	e_hp -= amount
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	update_hp_bar()
	
	if e_hp <= 0:
		if data.get("behavior", {}).get("explode_on_death", false) and not death_exploded:
			death_exploded = true
			_explode()
		queue_free()


func _explode() -> void:
	for n in get_tree().get_nodes_in_group("player"):
		var dist: float = global_position.distance_to(n.global_position)
		if dist < 60:
			n.take_damage(e_damage * 2)


func update_hp_bar() -> void:
	if hp_bar:
		hp_bar.size.x = 32.0 * e_hp / e_max_hp
