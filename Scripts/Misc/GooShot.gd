extends Area2D
var velocity = Vector2()
var enemy = load('res://Scripts/Actors/Enemy.gd').new()
var speed = 200
var dmg = 2
var direction = 1


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_direction():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start():
	position = Vector2()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y = speed * delta
	translate(velocity)
	$AnimatedSprite.play("goo_shot")
	
	
func _find_enemy_direction():
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_GooShot_body_entered(body):
	pass # Replace with function body.
