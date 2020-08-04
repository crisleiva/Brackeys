extends Particles2D
onready var character = load("res://Scripts/Actors/Character.gd").new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const REWIND_SPEED = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed_x = character.is_facing()
	var speed_y = 0
	var motion = Vector2(speed_x, speed_y) * REWIND_SPEED
	position = position + motion * delta 
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
