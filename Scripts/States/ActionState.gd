extends "res://Scripts/States/StateMachine.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("none")
	add_state("shoot")
	call_deferred("set_state", states.shoot)

func _get_transition(delta):
	match state:
		states.none:
			if Input.is_action_pressed("shoot") && fire_weapon():
				parent.shoot()
				return states.shoot
		states.shoot:
			if !Input.is_action_pressed("shoot") || !fire_weapon():
				return states.none


func fire_weapon():
	var main_states = parent.state_machines.states
	if parent.can_shoot:
		return ![main_states.jump, main_states.fall].has(parent.state_machines.state)
		
	

func _enter_state(new_state, old_state):
	match new_state:
		states.none:
			return 
		states.shoot:
			parent.anim_player.play("shoot")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
