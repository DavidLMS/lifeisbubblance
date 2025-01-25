extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton

func _ready() -> void:
	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test scene.tscn")


func _on_records_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
