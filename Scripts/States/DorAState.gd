extends "res://Scripts/States/StateMachine.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("dead")
	add_state("alive")
	call_deferred("set_state", "alive")
	
func _get_transition(delta):
	match state:
		states.alive:
			if parent.health > 0:
				return states.alive
		states.dead:
			if parent.health < 0:
				return states.dead
				
func _enter_state(new_state, old_state):
	match state:
		states.alive:
			parent.anim_player.play("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
