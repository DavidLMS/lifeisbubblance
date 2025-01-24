extends CharacterBody2D


@onready var sprite = $AnimatedSprite2D
@export var weapon:PackedScene
@export var weapon_offset:Vector2

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept"):
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
		sprite.flip_h = velocity.x>0 
		sprite.play("default")
	else:
		sprite.stop()
		 
