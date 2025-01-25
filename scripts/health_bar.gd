extends TextureProgressBar

@export var texture_green: Texture2D
@export var texture_yellow: Texture2D
@export var texture_red: Texture2D

@onready var character = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = Global.max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = Global.current_health
	if ratio > 0.5:
		texture_progress = texture_green
	elif ratio > 0.25:
		texture_progress = texture_yellow
	else:
		texture_progress = texture_red
