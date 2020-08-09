extends KinematicBody2D

# Player node for ai to follow
onready var player =  get_parent().get_node("res://Scenes/Actors/Character.tscn")
onready var raycasts = $RayCast
onready var area = $Area2D
onready var damage = 2
onready var move_speed = 2 * 32
onready var timer = $Timer
var health = 3
enum states {alive, dead}
var state = states.alive
var velocity = Vector2()
var gravity = 1200
var delay = 2
var is_destroyed = false
onready var Goo_Shot = preload("res://Scenes/Misc/GooShot.tscn")

func _hit(dmg):
	if state == states.dead:
		death()
	health -= dmg
	if health <= 0:
		state = states.dead
		health = 0
		death()

func shoot(player):
	var shot = Goo_Shot.instance()
	shot.position = $Muzzle.position
	get_parent().add_child(shot)
		
func death():
	is_destroyed = true
	$AnimatedSprite.play("death")
	$hitbox.disabled = true
	$Timer.start()
	
func attack():
	pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	_check_if_grounded()

func _on_Timer_timeout():
	queue_free()

func _check_if_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _on_Area2D_body_entered(body):
	if body.name == "Character":
		shoot(body)
		$AnimatedSprite.play("attacking")
		print("ha")
