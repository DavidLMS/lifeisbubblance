extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton

func _ready() -> void:
	if OS.get_name() == "Web":
		$MarginContainer/VBoxContainer/QuitButton.hide()
	play_button.grab_focus()
	await get_tree().process_frame
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_scene_music(0)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test scene.tscn")


func _on_records_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
