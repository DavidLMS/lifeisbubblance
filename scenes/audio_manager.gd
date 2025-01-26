extends Node

@onready var audio_player = AudioStreamPlayer.new()

var current_track = 0
const TRANSITION_TIME = 6.0
const MAX_VOLUME = 0
const MIN_VOLUME = -80

func _ready():
	add_child(audio_player)
	
	audio_player.stream = load("res://assets/music/menu.ogg") as AudioStreamOggVorbis
	audio_player.volume_db = MAX_VOLUME
	audio_player.bus = "Music"

func change_track(track_index: int):
	var track_path = ""
	match track_index:
		0: track_path = "res://assets/music/menu.ogg"
		1: track_path = "res://assets/music/main.ogg"
		2: track_path = "res://assets/music/leaderboard.ogg"
	
	var new_track = load(track_path) as AudioStreamOggVorbis
	
	var tween = create_tween()
	tween.tween_property(audio_player, "volume_db", MIN_VOLUME, TRANSITION_TIME)
	
	audio_player.stream = new_track
	audio_player.play()
	
	tween = create_tween()
	tween.tween_property(audio_player, "volume_db", MAX_VOLUME, TRANSITION_TIME)

func play_scene_music(scene_number: int):
	change_track(scene_number)
