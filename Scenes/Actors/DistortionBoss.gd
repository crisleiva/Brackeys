extends KinematicBody2D
var x_direction = -1
var y_direction = 1
var velocity: Vector2 = Vector2()


func _ready():
	pass

func _physics_process(delta):
	if is_on_wall():
		x_direction = x_direction * -1
	if is_on_floor():
		y_direction = y_direction * -1
	velocity.y = 20 * y_direction
	velocity.x = 50 * x_direction

	velocity = move_and_slide(velocity, Vector2.UP)