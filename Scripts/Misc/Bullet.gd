extends Area2D
signal dmg_enemy
var velocity = Vector2()
var player = load("res://Scripts/Actors/Character.gd").new()
var speed = 200
var direction = 1
var dmg = 2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func ConnectSignalTo(TargetNode):
	self.connect("dmg_enemy", TargetNode, "hit_by_bullet")

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
	emit_signal("dmg_enemy")
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	if "Distortion" in body.name:
		queue_free()
		print("out")
		body.death()
	queue_free()
		
