class_name Upgrades
extends Node


static var common_upgrades: Array[Dictionary] = [
	{
		"description": "Projectile count +1",
		"apply": func(ship: Ship)->void: ship.projectile_count_extra += 1
	},
	{
		"description": "Projectile count -1, damage +20%",
		"apply": func(ship: Ship)->void: ship.projectile_count_extra -= 1; ship.projectile_damage_mult += 0.2
	},
	{
		"description": "Projectiles +10%",
		"apply": func(ship: Ship)->void: ship.projectile_count_mult += 0.1
	},
	{
		"description": "Attack speed +10%",
		"apply": func(ship: Ship)->void: ship.shooting_interval_mult -= 0.1
	},
	{
		"description": "Damage +10%",
		"apply": func(ship: Ship)->void: ship.projectile_damage_mult += 0.1
	},
	{
		"description": "Damage +20%, projectiles -20%",
		"apply": func(ship: Ship)->void: ship.projectile_damage_mult += 0.2; ship.projectile_count_mult -= 0.2
	},
	{
		"description": "Projectile duration +10%",
		"apply": func(ship: Ship)->void: ship.projectile_ttl_mult += 0.1
	},
	{
		"description": "Projectile speed +15%",
		"apply": func(ship: Ship)->void: ship.projectile_speed_mult += 0.15
	},
	{
		"description": "Projectile size +10%",
		"apply": func(ship: Ship)->void: ship.projectile_size_mult += 0.10
	},
	{
		"description": "Spread +10%",
		"apply": func(ship: Ship)->void: ship.projectile_spread_angle_mult += 0.1
	},
	{
		"description": "Spread -10%",
		"apply": func(ship: Ship)->void: ship.projectile_spread_angle_mult -= 0.1
	},
	{
		"description": "Piercing +1",
		"apply": func(ship: Ship)->void: ship.projectile_piercing_mod += 1
	},
	{
		"description": "Health +50",
		"apply": func(ship: Ship)->void: ship.health += 50.0
	},
]
