class_name Game
extends Node2D


@export
var score_to_next_level_up := 15.0


@onready var ship: Ship = $GameEntities/Ship
@onready var enemy_spawn_area: NavigationRegion2D = $GameEntities/EnemySpawnArea
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var game_entities: Node2D = $GameEntities
@onready var elapsed_time_timer: Timer = $ElapsedTimeTimer
@onready var level_up_window: CanvasLayer = $LevelUpWindow
@onready var score_label: Label = $Hud/VBoxContainer/HBoxContainer/ScoreLabel
@onready var final_score_label: Label = $Hud/FinalScoreLabel
@onready var health_label: Label = $Hud/VBoxContainer/HBoxContainer2/HealthLabel
@onready var upgrade_choice_button_1: Button = $LevelUpWindow/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Upgrade_1
@onready var upgrade_choice_button_2: Button = $LevelUpWindow/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Upgrade_2
@onready var upgrade_choice_button_3: Button = $LevelUpWindow/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Upgrade_3


var enemies_killed := 0
var elapsed_time := 0.0
var score := 0
var remaining_score_to_next_level_up := score_to_next_level_up

var enemy_spawn_interval_sec := 2.5
var enemy_damage := 5.0
var enemy_speed := 165.0
var enemy_health := 100.0

var enemy_spawn_interval_sec_growth := -0.0025
var enemy_damage_growth := 0.01
var enemy_speed_growth := 0.002
var enemy_health_growth := 0.0025
var score_required_to_level_up_growth := 0.0075


var current_upgrade_options: Array[Dictionary]


func _ready() -> void:
	on_ship_health_changed()
	level_up_window.visibility_changed.connect(func(): set_game_paused(level_up_window.visible))
	spawn_enemy.call_deferred()
	enemy_spawn_timer.start(enemy_spawn_interval_sec)


func set_game_paused(is_paused: bool) -> void:
	PhysicsServer2D.set_active(not is_paused)
	get_tree().paused = is_paused


func scale_by_elapsed_time(value: float, scale_factor: float) -> float:
	return value * (1.0 + scale_factor * elapsed_time)


func level_up() -> void:
	remaining_score_to_next_level_up += scale_by_elapsed_time(score_to_next_level_up, score_required_to_level_up_growth)

	Upgrades.common_upgrades.shuffle()
	current_upgrade_options = Upgrades.common_upgrades.slice(0, 3)
	upgrade_choice_button_1.text = current_upgrade_options[0]["description"]
	upgrade_choice_button_2.text = current_upgrade_options[1]["description"]
	upgrade_choice_button_3.text = current_upgrade_options[2]["description"]
	level_up_window.visible = true


func on_enemy_destroyed() -> void:
	enemies_killed += 1
	update_score()

func update_elapsed_time() -> void:
	elapsed_time += elapsed_time_timer.wait_time
	update_score()

func update_score() -> void:
	var new_score := enemies_killed + int(elapsed_time)
	remaining_score_to_next_level_up -= new_score - score
	score = new_score
	score_label.text = str(score)
	if remaining_score_to_next_level_up <= 0:
		level_up()


func spawn_enemy() -> void:
	var spawn_point := NavigationServer2D.region_get_random_point(enemy_spawn_area.get_rid(), 0, true)
	var enemy := Enemy.spawn(
		game_entities,
		ship,
		spawn_point,
		scale_by_elapsed_time(enemy_speed, enemy_speed_growth),
		scale_by_elapsed_time(enemy_damage, enemy_damage_growth),
		scale_by_elapsed_time(enemy_health, enemy_health_growth)
	)
	enemy.destroyed.connect(on_enemy_destroyed)
	enemy_spawn_timer.start(scale_by_elapsed_time(enemy_spawn_interval_sec, enemy_spawn_interval_sec_growth))


func upgrade_chosen(upgrade: int) -> void:
	level_up_window.visible = false
	current_upgrade_options[upgrade]["apply"].call(ship)


func on_ship_destroyed() -> void:
	set_game_paused(true)
	final_score_label.visible = true
	final_score_label.text = "FINAL SCORE: " + str(score)

func on_ship_health_changed() -> void:
	health_label.text = str(floori(ship.health))
