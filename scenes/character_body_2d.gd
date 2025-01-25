extends CharacterBody2D


@onready var sprite = $AnimatedSprite2D
@export var weapon:PackedScene
@export var weapon_offset:Vector2

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var shooting = false


func shooting_finished():
	shooting = false
	
func _ready() -> void:
	Events.shoot_finished.connect(shooting_finished)



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

	if Input.is_action_just_pressed("ui_accept") and not shooting:
		sprite.play("shoot")
		shooting = true
		await get_tree().create_timer(0.3).timeout
		var shoot = weapon.instantiate()
		get_tree().root.add_child(shoot)
		shoot.global_position = global_position + weapon_offset

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

	if velocity.x != 0:
		sprite.flip_h = velocity.x<0 
		sprite.play("default")
	else:
		if sprite.animation == "default":
			sprite.stop()
		 
		


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "shoot":
		sprite.play("default")
