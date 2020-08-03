extends KinematicBody2D
var velocity = Vector2()
var player = load("res://Character.gd").new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = player.is_facing()
	if $Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity)
