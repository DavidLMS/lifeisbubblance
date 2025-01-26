extends Timer

var time_start :float = 0.0
var time_now :float = 0.0
var time_elapsed :float

func _ready() -> void:
	time_start = Time.get_unix_time_from_system()
	
func _process(delta: float) -> void:
	time_now = Time.get_unix_time_from_system()
	time_elapsed = time_now - time_start
	Global.score = snappedf(time_elapsed, 0.01) * 100
	$"../ScoreLabel".text = "SCORE: " + str(Global.score)

#func updateTime() -> void:
	#Global.score += 1
	#$"../ScoreLabel".text = "SCORE: "+str(Global.score)

#func _on_timeout() -> void:
	#updateTime()
