extends Timer

func updateTime() -> void:
	Global.score += 1
	$"../ScoreLabel".text = "SCORE: "+str(Global.score)

func _on_timeout() -> void:
	updateTime()
