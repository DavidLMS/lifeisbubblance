extends Node2D

var entry_scene = preload("res://scenes/entry_leaderboard.tscn")

@export var leaderboard_internal_name: String

@onready var entries_container: VBoxContainer = %Entries
@onready var username: TextEdit = %Username

func _ready() -> void:
	await _load_entries()

func _create_entry(entry: TaloLeaderboardEntry) -> void:
	var entry_instance = entry_scene.instantiate()
	entry_instance.set_data(entry.position, entry.player_alias.identifier, entry.score)
	entries_container.add_child(entry_instance)

func _build_entries() -> void:
	for child in entries_container.get_children():
		child.queue_free()

	for entry in Talo.leaderboards.get_cached_entries(leaderboard_internal_name):
		_create_entry(entry)

func _load_entries() -> void:
	var page = 0
	var done = false

	while !done:
		var res = await Talo.leaderboards.get_entries(leaderboard_internal_name, page)
		var entries = res[0]
		var last_page = res[2]

		if last_page:
			done = true
		else:
			page += 1

	_build_entries()

func _on_submit_pressed() -> void:
	pass
