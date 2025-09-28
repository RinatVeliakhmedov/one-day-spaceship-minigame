class_name Ship
extends RigidBody2D


signal health_changed
signal destroyed


@onready var _timer: Timer = $ShootingTimer
@onready var _projectile_release_point: Marker2D = $ProjectileReleasePoint

@export var health := 100.0:
	set(value):
		if health != value:
			health = value
			health_changed.emit()

@export var forward_thrust := 1000.0
@export var side_thrust := 500.0
@export var max_rotation_rad_per_sec := deg_to_rad(270.0)

@export var default_shooting_interval_sec := 0.35
@export var shooting_interval_mult := 1.0

@export var default_projectile_damage := 100.0
@export var default_projectile_speed := 1200.0
@export var default_projectile_ttl := 0.3
@export var default_projectile_spread_angle := deg_to_rad(45.0)
@export var default_projectile_count := 1
@export var default_projectile_piercing := 0

@export var projectile_damage_mult := 1.0
@export var projectile_speed_mult := 1.0
@export var projectile_ttl_mult := 1.0
@export var projectile_spread_angle_mult := 1.0
@export var projectile_count_extra := 0
@export var projectile_count_mult := 1.0
@export var projectile_piercing_mod := 0
@export var projectile_size_mult := 1.0


func _physics_process(delta: float) -> void:
	var target_angle := (get_global_mouse_position() - global_position).angle()
	rotation = rotate_toward(rotation, target_angle, max_rotation_rad_per_sec * delta)

	var force := int(Input.is_action_pressed("thrust")) * Vector2.RIGHT.rotated(rotation) * forward_thrust
	force += int(Input.is_action_pressed("left")) * Vector2.UP.rotated(rotation) * side_thrust
	force += int(Input.is_action_pressed("right")) * Vector2.DOWN.rotated(rotation) * side_thrust
	apply_force(force)
	if Input.is_action_pressed("shoot") and _timer.is_stopped():
		shoot()


func shoot() -> void:
	_timer.start(default_shooting_interval_sec * shooting_interval_mult)

	var projectile_count := ceili((default_projectile_count + projectile_count_extra) * projectile_count_mult)
	var spread_angle := default_projectile_spread_angle * projectile_spread_angle_mult
	var projectile_speed := default_projectile_speed * projectile_speed_mult + linear_velocity.length()
	var projectile_ttl := default_projectile_ttl * projectile_ttl_mult
	var projectile_damage := default_projectile_damage * projectile_damage_mult
	var projectile_piercing := default_projectile_piercing + projectile_piercing_mod

	if projectile_count < 1:
		return

	if projectile_count == 1:
		Projectile.fire(get_parent(), _projectile_release_point.global_position, global_rotation, projectile_speed, projectile_ttl, projectile_damage, projectile_piercing, projectile_size_mult)
		return

	var step := spread_angle / maxi(1, projectile_count - 1)
	var start := -spread_angle * 0.5
	for i in range(projectile_count):
		var angle := start + i * step
		var projectile_rotation := global_rotation + angle
		Projectile.fire(get_parent(), _projectile_release_point.global_position, projectile_rotation, projectile_speed, projectile_ttl, projectile_damage, projectile_piercing, projectile_size_mult)


func take_damage(damage: float) -> void:
	health = maxf(health - damage, 0.0)
	if health <= 0:
		destroyed.emit()
		queue_free()
