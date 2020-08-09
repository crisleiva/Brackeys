extends Area2D
var velocity = Vector2()
var player = load("res://Scripts/Actors/Character.gd").new()
var speed = 200
var direction = 1
var dmg = 2
const COOLDOWN = 3

func set_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start():
	position = Vector2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)
	$AnimatedSprite.play("Shot")
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	var count = 0
	if body.name == "enemy":
		body._hit(dmg)
	if body.name == "enemy2":
		body._hit(dmg)
	queue_free()
		
