extends Node2D

signal shoot_finished

signal bubble_time
signal player_time
signal bubble_hit_wall
signal death

var current_state: States = States.BubbleTime
var bubbles_green = 0

var bubble_time_wait = 10.0
var player_time_wait = 5.0

var first_bubble_hit = true

func init():
	current_state = States.PlayerTime
	bubbles_green = 0
	first_bubble_hit = true
	print("events init")

func start_bubble_time():
	current_state = States.BubbleTime
	bubble_time.emit()

func start_player_time():
	current_state = States.PlayerTime
	player_time.emit()

func is_bubble_time():
	return current_state == States.BubbleTime

func is_player_time():
	return current_state == States.PlayerTime

enum States {
	Waiting, BubbleTime, PlayerTime
}
