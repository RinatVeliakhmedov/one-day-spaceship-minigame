class_name Projectile
extends Area2D


const _scene := preload("res://projectile.tscn")


var _speed: float
var _ttl: float
var _damage: float
var _piercing: int

var _lifetime := 0.0


static func fire(parent: Node, spawn_position: Vector2, initial_rotation: float, speed: float, ttl_sec: float, damage: float, piercing: int, size_mult: float) -> void:
	var projectile: Projectile = _scene.instantiate()
	parent.add_child(projectile)

	projectile.global_position = spawn_position
	projectile.rotation = initial_rotation
	projectile._speed = speed
	projectile._ttl = ttl_sec
	projectile._damage = damage
	projectile._piercing = piercing
	projectile.scale = Vector2(size_mult, size_mult)


func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * _speed * delta
	_lifetime += delta
	if _lifetime >= _ttl:
		queue_free()


func _on_enemy_hit(enemy: Node2D) -> void:
	enemy.take_damage(_damage)
	_piercing -= 1
	if _piercing < 0:
		queue_free()
