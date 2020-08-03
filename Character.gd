extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var BULLET = preload("res://Bullet.tscn")

var run_speed = 350
var jump_speed = -1000
var gravity = 2500
var facing = ""

var velocity = Vector2()

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')
	var held_down = Input.is_action_pressed("ui_up")

	if is_on_floor() and jump:
		velocity.y = jump_speed
	if right:
		$AnimatedSprite.play("right")
		facing = "right"
		velocity.x += run_speed
	if left:
		$AnimatedSprite.play("left")
		facing = "left"
		velocity.x -= run_speed
	if held_down:
		var bullet = BULLET.instance()
		bullet.global_position = self.global_position	
		get_parent().add_child(bullet)
	
func is_facing():
	var velo = 0
	if facing == "left":
		velo = -200
	if facing == "right": 
		velo = 200
	return velo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))

