extends KinematicBody2D
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
	var format_str = "Dmg numbers %f, Health numbers %f"
	var actual = format_str % [health, dmg]
	
func death():
	if health < 0:
		is_destroyed = true
		$AnimatedSprite.play("Destroyed")
		$CollisionShape2D.disabled = true
		$Timer.start()
	print("not dead")
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()
