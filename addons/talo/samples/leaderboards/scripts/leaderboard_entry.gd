extends Label

func _set_pos(pos: int) -> void:
	text = text.replace("{pos}", str(pos + 1))

func _set_username(username: String) -> void:
	text = text.replace("{username}", username)

func _set_score(score: int) -> void:
	text = text.replace("{score}", str(int(score)))

func set_data(entry: TaloLeaderboardEntry) -> void:
	_set_pos(entry.position)
	_set_username(entry.player_alias.identifier)
	_set_score(entry.score)
