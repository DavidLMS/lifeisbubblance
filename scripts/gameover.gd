extends Node2D

var entry_scene = preload("res://scenes/entry_leaderboard.tscn")

@onready var username: TextEdit = %Username

func _ready() -> void:
	%ScoreLabel.text = "SCORE: " + str(Global.score)

func _on_submit_pressed() -> void:
	await Talo.players.identify("username", username.text)
	var score = Global.score

	var res = await Talo.leaderboards.add_entry("main", score)
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")
	
