extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collider = $CollisionShape2D

@export var weapon:PackedScene
@export var weapon_offset:Vector2
@export var camera: Camera2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var shooting = false
var is_death = false
var _camera_shake_noise: FastNoiseLite

func shooting_finished():
	shooting = false
	
func _ready() -> void:
	_camera_shake_noise = FastNoiseLite.new()
	Events.shoot_finished.connect(shooting_finished)
	Events.death.connect(on_death)
	Events.bubble_hit_wall.connect(bubble_hit_wall)

func bubble_hit_wall():
	if Events.bubbles_green == 0:
		get_tree().create_timer(Events.bubble_time_wait).timeout.connect(end_bubble_time)
	Events.bubbles_green += 1

func end_bubble_time():
	Events.bubbles_green = 0
	Events.start_player_time()
	get_tree().create_timer(Events.bubble_time_wait).timeout.connect(end_player_time)
	
func end_player_time():
	Events.start_bubble_time()

func on_death() -> void:
	Events.start_player_time()
	Engine.time_scale = 1.0
	is_death = true
	set_physics_process(false)
	collider.queue_free()
	await get_tree().create_timer(.6).timeout
	var death_tween = get_tree().create_tween()
	sprite.material = null
	death_tween.tween_method(death, 0.0, 1.0, 1.0)
	get_tree().create_timer(1.1).timeout.connect(the_end)

func the_end():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func death(value: float):
	position.y -= 4.0
	sprite.modulate.a = 1.0 - value

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_death:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		Global.score = 0
		#if !(OS.get_name() == "Web"):
		#	get_tree().quit()

	var direction := Input.get_axis("ui_left", "ui_right") if not Events.is_bubble_time() or Events.bubbles_green == 0 else 0.0

	if Input.is_action_just_pressed("ui_accept") and not shooting:
		sprite.play("shoot")
		shooting = true
		await get_tree().create_timer(0.3).timeout
		var shoot = weapon.instantiate()
		get_tree().root.add_child(shoot)
		shoot.global_position = global_position + weapon_offset
	else:
		if sprite.animation != "shoot":
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)	
		move_and_slide()

	if velocity.x != 0:
		sprite.flip_h = velocity.x<0 
		if sprite.animation != "shoot" and not sprite.is_playing():
			sprite.play("default")
	else:
		if sprite.animation == "default":
			sprite.stop()

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "shoot":
		sprite.play("default")

func apply_effect(shake: bool = true):
	var blink_tween = get_tree().create_tween()
	blink_tween.tween_method(set_shader_intensity, 1.0, 0.0, 0.5)
	if shake:
		var camera_tween = get_tree().create_tween()
		camera_tween.tween_method(start_camera_shake, 5.0, 1.0, 0.5)


func start_camera_shake(intensity: float):
	var camera_offset = _camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera.offset.x = camera_offset
	camera.offset.y = camera_offset

func set_shader_intensity(value: float):
	sprite.material.set_shader_parameter("blink_intensity", value)
