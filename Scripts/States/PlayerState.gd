extends "res://Scripts/States/StateMachine.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("shoot")
	call_deferred("set_state", states.idle)
# Input that detects when an event is being used. Use is for jump and ground detection plus idle


func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_movement()
	parent._apply_gravity(delta)
		
func _input(event):
	
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump") && parent.is_grounded:
			parent.velocity.y = parent.max_jump_velo
			parent.is_jumping = true
	if state == states.jump:
		if event.is_action_released("jump") && parent.velocity.y < parent.min_jump_velo:
			parent.velocity.y = parent.min_jump_velo
	
	#add logic to stop a plyer from double jumping LOL
	
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
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
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
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
		states.shoot:
			parent.anim_player.play("shoot")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
