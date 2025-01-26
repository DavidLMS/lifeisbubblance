extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var collider = $Area2D/CollisionShape2D
@onready var rigid_collider = $CollisionShape2D
@onready var keys = $keys

@export var player_time_texture: Texture2D
@export var bubble_time_texture: Texture2D
@export var next_bubble: PackedScene
@export var next_bubble_count: int
@export var angle_offset = PI * 0.1
@export var scale_reduction = .5
@export var scale_min = 1
@export var damage = 25

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bubble_size: float = 4.0
var waiting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = player_time_texture if Events.is_player_time() else bubble_time_texture
	Events.player_time.connect(set_player_texture)
	Events.bubble_time.connect(set_bubble_texture)
	sprite.scale = Vector2(bubble_size, bubble_size)
	collider.shape.radius = collider.shape.radius * bubble_size / 4.0
	rigid_collider.shape.size = rigid_collider.shape.size * bubble_size / 4.0
 
func set_player_texture():
	sprite.texture = player_time_texture
func set_bubble_texture():
	sprite.texture = bubble_time_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting:
		if Input.is_action_just_pressed("ui_left"):
			end_waiting()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapon"):
		if Events.first_bubble_hit:
			Events.first_bubble_hit = false
			Events.start_bubble_time()
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
				get_tree().root.add_child(nb)
		# queue_free()
		animation_player.play("explosion")

func get_quadrant(velocity: Vector2, i: int) -> Vector2:
	return velocity.rotated(angle_offset if i else -angle_offset)

func set_sprite_scale(new_scale):
	bubble_size = new_scale

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.apply_effect()
		Global.take_damage(damage)
		#queue_free()
		animation_player.play("explosion")
	if body.is_in_group("walls"):
		apply_effect()
		if Events.is_bubble_time():
			Events.bubble_hit_wall.emit()
			Engine.time_scale = 0.2
			keys.visible = true
			waiting = true
			get_tree().create_timer(.2).timeout.connect(end_waiting)

func end_waiting():
	Engine.time_scale = 1.0
	waiting = false
	keys.visible = false

func apply_effect(shake:bool = true):
	var blink_tween = get_tree().create_tween()
	blink_tween.tween_method(set_shader_intensity, 1.0, 0.0, 0.5)

func set_shader_intensity(value: float):
	sprite.material.set_shader_parameter("blink_intensity", value)
