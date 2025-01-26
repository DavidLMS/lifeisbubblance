extends Node2D

var entry_scene = preload("res://scenes/entry_leaderboard.tscn")

@onready var username: LineEdit = $UI/MarginContainer/VBoxContainer/LineEdit
#@onready var username: TextEdit = %Username

func _ready() -> void:
	%ScoreLabel.text = "SCORE: " + str(Global.score)
	username.grab_focus()

func _on_submit_pressed() -> void:
	var username = UnicodeNormalizer.normalize(username.text)
	await Talo.players.identify("username", username)
	var score = Global.score

	var res = await Talo.leaderboards.add_entry("main", score)
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")
