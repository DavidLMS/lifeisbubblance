extends Node

var max_health: int = 100
var current_health: int = 100
var score: int = 0

var bubble_count:int = 2

func take_damage(damage: int):
	if Events.is_player_time():
		current_health -= damage
	else:
		current_health += damage
	if current_health > max_health:
		current_health = max_health
	if current_health <= 0:
		Events.death.emit()
