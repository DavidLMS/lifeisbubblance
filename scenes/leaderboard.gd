extends Node2D

var entry_scene = preload("res://scenes/entry_leaderboard.tscn")

@export var leaderboard_internal_name: String

@onready var leaderboard_name: Label = %LeaderboardName
@onready var entries_container: VBoxContainer = %Entries
@onready var info_label: Label = %InfoLabel
@onready var username: TextEdit = %Username

var _entries_error: bool

func _ready() -> void:
	leaderboard_name.text = leaderboard_name.text.replace("{leaderboard}", leaderboard_internal_name)
	await _load_entries()
	_set_entry_count()

func _set_entry_count():
	if entries_container.get_child_count() == 0:
		info_label.text = "No entries yet!" if not _entries_error else "Failed loading leaderboard %s. Does it exist?" % leaderboard_internal_name
	else:
		info_label.text = "Only top 10 are shown!"

func _create_entry(entry: TaloLeaderboardEntry) -> void:
	var entry_instance = entry_scene.instantiate()
	entry_instance.set_data(entry)
	entries_container.add_child(entry_instance)

func _build_entries() -> void:
	for child in entries_container.get_children():
		child.queue_free()

	var entries = Talo.leaderboards.get_cached_entries(leaderboard_internal_name)

	# Ordenar las entradas por score (mayor a menor)
	entries.sort_custom(func(a, b): return a.score > b.score)

	# Limitar a las 10 mejores
	if entries.size() > 10:
		entries = entries.slice(0, 10)

	for entry in entries:
		entry.position = entries.find(entry) + 1
		_create_entry(entry)

func _load_entries() -> void:
	var page = 0
	var done = false

	while !done:
		var res = await Talo.leaderboards.get_entries(leaderboard_internal_name, page)

		if res.size() == 0:
			_entries_error = true
			return

		var last_page = res[2]

		if last_page:
			done = true
		else:
			page += 1

	_build_entries()

func _on_submit_pressed() -> void:
	await Talo.players.identify("username", username.text)
	var score = RandomNumberGenerator.new().randi_range(0, 100)

	var res = await Talo.leaderboards.add_entry(leaderboard_internal_name, score)
	info_label.text = "You scored %s points" % [score, " Your highscore was updated!" if res[1] else ""]

	_build_entries()
