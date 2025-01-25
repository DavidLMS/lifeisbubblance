extends RigidBody2D

@export var next_bubble: PackedScene
@export var next_bubble_count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapon"):
		area.queue_free()
		Events.shoot_finished.emit()
		if not next_bubble:
			next_bubble = (load(scene_file_path) as PackedScene)
		for i in range(next_bubble_count):
			var nb = next_bubble.instantiate()
			nb.global_position = global_position
			nb.linear_velocity = linear_velocity + Vector2(50, 100)  - i * Vector2(100, 200)
			get_tree().root.add_child(nb)
		queue_free()
