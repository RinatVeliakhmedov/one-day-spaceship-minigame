class_name Enemy
extends RigidBody2D

const _scene := preload("res://enemy.tscn")


signal destroyed


var _ship: Ship
var _speed: float
var _damage: float
var _health: float


static func spawn(parent: Node, ship: Ship, spawn_position: Vector2, speed: float, damage: float, health: float) -> Enemy:
	var enemy: Enemy = _scene.instantiate()
	parent.add_child(enemy)
	enemy.global_position = spawn_position
	enemy._ship = ship
	enemy._speed = speed
	enemy._damage = damage
	enemy._health = health
	return enemy


func take_damage(damage: float) -> void:
	_health -= damage
	if _health <= 0:
		destroyed.emit()
		queue_free()


func _physics_process(_delta: float) -> void:
	look_at(_ship.global_position)
	apply_force(Vector2.RIGHT.rotated(rotation) * _speed)


func _hit_player_ship(ship: Ship) -> void:
	ship.take_damage(_damage)
	destroyed.emit()
	queue_free()
