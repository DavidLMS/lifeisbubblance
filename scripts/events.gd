extends Node2D

signal shoot_finished

signal bubble_time
signal player_time

signal death

var current_state: States = States.PlayerTime

enum States {
	Waiting, BallTime, PlayerTime
}
