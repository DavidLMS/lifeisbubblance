extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio_stream_player_2d.play()

func _on_animation_finished(anim_name: StringName) -> void:
	Events.shoot_finished.emit()
	queue_free() 
