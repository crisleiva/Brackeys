extends KinematicBody2D
var health = 10
var is_destroyed = false
var rewind_dmg = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func hit_by_bullet(dmg):
	health -= dmg
	if health < 0:
		var format_str = "Dmg numbers %f, Health numbers %f"
		var actual = format_str % [health, dmg]
		death()
	
func death():
	is_destroyed = true
	$AnimatedSprite.play("Destroyed")
	$CollisionShape2D.disabled = true
	$Timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	# when a character enters start a timer and when it hits 0 && his shield is down restart
	if body.name == "Character":
		body.rewind_loss(rewind_dmg)
