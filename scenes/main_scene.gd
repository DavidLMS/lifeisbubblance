extends Node2D

@export var bubble_scene: PackedScene
@export var origin: Marker2D

@onready var animation = $AnimationPlayer

func _init() -> void:
	Events.init()

func popup_bubbles() -> void:
	for i in range(Global.bubble_count):
		var nb = bubble_scene.instantiate()
		nb.global_position = origin.global_position
		nb.linear_velocity = Vector2(-200, 200).rotated(randf_range(-PI*0.2, PI*0.2))
		get_tree().root.add_child(nb)
	await get_tree().create_timer(5).timeout
	animation.play("gun")
