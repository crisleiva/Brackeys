extends "res://Scripts/States/StateMachine.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("shoot")
	add_state("fall")
	call_deferred("set_state", states.idle)
# Input that detects when an event is being used. Use is for jump and ground detection plus idle


func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_movement()
	parent._apply_gravity(delta)

func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0 :
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
				
	return null
					
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.run:
			parent.anim_player.play("run")
		states.jump:
			parent.anim_player.play("jump")
		states.fall:
			parent.anim_player.play("fall")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
