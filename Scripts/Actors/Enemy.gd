extends Node

# Player node for ai to follow
onready var player =  get_parent().get_node("res://Scenes/Actors/Character.tscn")

onready var area = $Area2D
onready var damage = 2
var health = 3
enum states {alive, dead}
var state = states.alive
var velocity = Vector2()
onready var move_speed = 2 * 32
onready var timer = $Timer
var delay = 2
var is_destroyed = false
onready var Goo_Shot = preload("res://Scenes/Misc/GooShot.tscn")

func _hit(dmg):
	print("here")
	if state == states.dead:
		return
	health -= dmg
	if health <= 0:
		health = 0
		death()

func shoot(player):
	var shot = Goo_Shot.instance()
	shot.position = $Muzzle.position
	var direction = (player.position - self.position).normalized()
	get_parent().add_child(shot)
		
func death():
	is_destroyed = true
	$hitbox.disabled = true
	$Timer.start()
	pass
	
func attack():
	pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func _on_Timer_timeout():
	queue_free()



func _on_Area2D_body_entered(body):
	if body.name == "Character":
		print("ha")
