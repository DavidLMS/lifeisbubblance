extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var collider = $Area2D/CollisionShape2D
@onready var rigid_collider = $CollisionShape2D

@export var next_bubble: PackedScene
@export var next_bubble_count: int
@export var angle_offset = PI * 0.1
@export var scale_reduction = .5
@export var scale_min = 1

var bubble_size: float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.scale = Vector2(bubble_size, bubble_size)
	collider.shape.radius = collider.shape.radius * bubble_size / 4.0
	rigid_collider.shape.size = rigid_collider.shape.size * bubble_size / 4.0
	print(collider.shape.radius)
	print(rigid_collider.shape.size)

 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapon"):
		area.queue_free()
		Events.shoot_finished.emit()
		if sprite.scale.x > scale_min:
			if not next_bubble:
				next_bubble = (load(scene_file_path) as PackedScene)
			for i in range(next_bubble_count):
				var nb = next_bubble.instantiate()
				nb.global_position = global_position
				var velocity_correction:Vector2 = get_quadrant(linear_velocity, i)
				nb.linear_velocity = velocity_correction
				nb.set_sprite_scale(sprite.scale.x * scale_reduction)
				print(scale)
				print(nb.scale)
				get_tree().root.add_child(nb)
		queue_free()

func get_quadrant(velocity: Vector2, i: int) -> Vector2:
	return velocity.rotated(angle_offset if i else -angle_offset)

func set_sprite_scale(new_scale):
	bubble_size = new_scale
