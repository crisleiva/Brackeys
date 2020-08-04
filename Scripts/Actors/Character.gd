extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var REWIND = preload("res://Scenes/Misc/Bullet.tscn")
onready var DIST = preload("res://Scenes/Actors/Distortion.tscn")
var timer = null
var cooldown = 3
var run_speed = 350
var jump_speed = -1000
var gravity = 2500
var health = 6
var dir = ""
var velocity = Vector2()
var bullet_delay = 2
var can_shoot = true

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')
	var held_down = Input.is_action_pressed("ui_end")

	if is_on_floor() and jump:
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
		$AnimatedSprite.play("right")
		$AnimatedSprite.flip_h = false
		if sign($Muzzle.position.x) == -1:
			$Muzzle.position.x *= -1
		
	if left:
		velocity.x -= run_speed
		
		$AnimatedSprite.flip_h = true
		if sign($Muzzle.position.x) == 1:
			$Muzzle.position.x *= -1
	if held_down && can_shoot:
		shoot()
		
		
func shoot():
	var bullet = REWIND.instance()
	if sign($Muzzle.position.x) == 1:
		bullet.set_direction(1)
	else: 
		bullet.set_direction(-1)
	
	get_parent().add_child(bullet)
	bullet.global_position = $Muzzle.global_position
	can_shoot = false
	timer.start()
	

	

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = bullet_delay
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	set_process_input(true)
	set_process(true)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))

func on_timeout_complete():
	can_shoot = true

func _on_Distortion_hit():
	print("hit")


func _on_Distortion_body_entered(body):
	print("touching") # Replace with function body.
