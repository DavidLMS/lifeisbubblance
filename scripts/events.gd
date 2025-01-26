extends Node2D

signal shoot_finished

signal bubble_time
signal player_time

var current_state: States = States.BallTime

enum States {
	Waiting, BallTime, PlayerTime
}
