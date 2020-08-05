extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var REWIND = preload("res://Scenes/Misc/Bullet.tscn")
onready var DIST = preload("res://Scenes/Actors/Distortion.tscn")
onready var raycasts = $RayCasts
var timer = null
const RUN_SPEED = 5 * 32
const JUMP_POWER = -750
const GRAVITY = 1200
const SLOPE_STOP = 64
var is_grounded
var health = 6
var velocity = Vector2()
var bullet_delay = 1
var can_shoot = true
var damage = 0
var can_rewind = false
var weapons = {
	"pistol": {
		damage = 1,
		can_rewind = false
	},
	"rewind_gun": {
		damage = 0,
		can_rewind = true
	}
}

func _get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, RUN_SPEED * move_direction, 0.2)
	if move_direction != 0:
		$Body.scale.x = move_direction
	
	if Input.is_action_pressed("move_left"):
		if sign($Muzzle.position.x) == 1:
			$Muzzle.position *= -1
	if Input.is_action_pressed("move_right"):
		if sign($Muzzle.position.x) == -1:
			$Muzzle.position *= -1
	if Input.is_action_pressed("shoot") && can_shoot:
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
	
func _input(event):
	if event.is_action_pressed("jump") && is_grounded:
		velocity.y = JUMP_POWER
	

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
func _physics_process(delta):
	_get_input()
	velocity.y += GRAVITY * delta 
	velocity = move_and_slide(velocity, Vector2(0, -1), SLOPE_STOP)
	is_grounded = _check_is_grounded()


func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false
	
	
func on_timeout_complete():
	can_shoot = true

func _on_Distortion_hit():
	print("hit")


func _on_Distortion_body_entered(body):
	print("touching") # Replace with function body.
