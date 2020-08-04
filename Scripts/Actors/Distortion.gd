extends KinematicBody2D
signal hit
var health = 10
var is_destroyed = false


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func hit_by_bullet(dmg):
	health -= dmg
	print("ouch")
	
func death():
	is_destroyed = true
	$AnimatedSprite.play("Destroyed")
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
