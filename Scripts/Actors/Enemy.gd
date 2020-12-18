extends KinematicBody2D

# Player node for ai to follow
# onready var player =  get_parent().get_node("res://Scenes/Actors/Character.tscn")
onready var raycasts = $RayCast
onready var area = $Area2D
onready var damage = 2
onready var move_speed = 2 * 32
onready var timer = $Timer
var health = 3
var player = null
enum states {alive, dead}
var state = states.alive
var is_grounded
var velocity: Vector2 = Vector2.ZERO
var gravity: int = 1200
var delay: int = 2
var is_destroyed: bool = false
onready var Goo_Shot = preload("res://Scenes/Misc/GooShot.tscn")

func _hit(dmg):
	if state == states.dead:
		death()
	health -= dmg
	if health <= 0:
		state = states.dead
		health = 0
		death()

# func shoot(player):
# 	var shot = Goo_Shot.instance()
# 	shot.position = $Muzzle.position
# 	get_parent().add_child(shot)
		
func death():
	is_destroyed = true
	$AnimatedSprite.play("death")
	$hitbox.disabled = true
	$Timer.start()
	
func attack():
	if player:
		$AnimatedSprite.play("attacking")
		player.hit(damage)
	else:
		$AnimatedSprite.play("idle")

func enemy_move(delta):
	# on a timer move to point a then point b, then back
	# when it spots the player. Move towards that area
	velocity = Vector2.ZERO
	velocity.y += gravity * delta 
	is_grounded = _check_is_grounded()
	if player:
		velocity = position.direction_to(player.position) * move_speed
	velocity = move_and_slide(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	enemy_move(_delta)
	attack()

func _on_Timer_timeout():
	queue_free()

func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _on_Area2D_body_entered(body):
	if body.name == "Character":
		player = body

func _on_Area2D_body_exited(_body):
	player = null