#Character Script
extends KinematicBody2D
signal died
signal rewind
signal health_changed
signal protection_changed
#Preloading Bullet + Distortion Enemy
onready var REWIND = preload("res://Scenes/Misc/Bullet.tscn")
onready var DIST = preload("res://Scenes/Actors/Distortion.tscn")
# Readying up Raycast to detect ground collision
onready var raycasts = $RayCasts
onready var anim_player = $AnimatedSprite
onready var state_machines = $PlayerState

enum states {ALIVE, DEAD}
var state = states.ALIVE
# Two health variables to be used by our GUI
export var max_health = 6
export var max_r_protect = 6
var health = max_health
var rewind_protect = max_r_protect
# Timer that helps with bullet delay
var timer = null
var bullet_delay = 1
var can_shoot = true
# State machine

#Constants and vars added for our movement
const RUN_SPEED = 5 * 32
const SLOPE_STOP = 64
var gravity
var is_grounded
var is_jumping = false

var velocity = Vector2()

var max_jump_height = 3.0 * Globals.TILE_SIZE
var min_jump_height = 0.8 * Globals.TILE_SIZE

var jump_duration = 0.5
var max_jump_velo
var min_jump_velo
#Weapon switching and damage numbers. 
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


#Our movement function 
func _handle_move_input():
	# Will return a negative or positive number which will then be interpolated into velocity
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, RUN_SPEED * move_direction, 0.2)
	# Movement direction will always be +1 -1 that determines our players left or right
	if abs(move_direction) < 16:
		$Body.scale.x = move_direction
		
	if move_direction == 1:
		if sign($Muzzle.position.x) == -1:
			$Muzzle.position.x *= -1
		anim_player.flip_h = false
	if move_direction == -1:
		if sign($Muzzle.position.x) == 1:
			$Muzzle.position.x *= -1
		anim_player.flip_h = true
	# Creating checks for animations and to set our Gun's position to allow us to shoot in the right direction

# Shoot creates a new instance of our bullet and creates the position 
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
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velo = -sqrt(2 * gravity * max_jump_height)
	min_jump_velo = -sqrt(2 * gravity * min_jump_height)
	
	# Timer that creates our bullet delay
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = bullet_delay
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	set_process_input(true)
	set_process(true)


func hit(dmg):
	if state == states.DEAD:
		anim_player.play("death")
	health -= dmg
	emit_signal("health_changed", health)
	if health <= 0:
		state = states.DEAD
	anim_player.play("attacked")
		

func rewind_loss(rewind_dmg):
	rewind_protect -= rewind_dmg
	emit_signal("protection_changed", rewind_protect)
	if rewind_protect <= 0:
		var spawn = get_parent().get_node("Spawn")
		self.position = spawn.position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_handle_move_input()
	
func _apply_movement():
	if is_jumping && velocity.y >= 0:
		is_jumping = false
	
func _apply_gravity(delta):
	velocity.y += gravity * delta 
	velocity = move_and_slide(velocity, Vector2(0, -1), SLOPE_STOP)
	is_grounded = _check_is_grounded()

# We're checking our raycasts to detect ground collision. Its more accurate. I think
func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false
	
# When the Timer ends it calls this signal and switches our var to true to allow another bullet
func on_timeout_complete():
	can_shoot = true

func _on_Distortion_hit():
	print("hit")


func _on_Distortion_body_entered(body):
	print("touching") # Replace with function body.
