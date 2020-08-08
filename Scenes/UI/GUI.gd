extends MarginContainer
onready var number = $HBoxContainer/bars/bar/Count/Background/Number
onready var health_bar = $HBoxContainer/bars/bar/LifeGauge
onready var rewind_protect = $HBoxContainer/bars/bar/RewindGauge
onready var tween = $Tween
var animated_health = 0
var animated_protection = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var players_max_protect = get_parent().get_parent().get_parent().max_r_protect
	var players_max_health = get_parent().get_parent().get_parent().max_health
	health_bar.max_value = players_max_health
	rewind_protect.max_value = players_max_protect
	update_health(players_max_health)
	update_protection(players_max_protect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var round_health_value = round(animated_health)
	var round_protection_value = round(animated_protection)
	number.text = str(round_health_value)
	health_bar.value = round_health_value
	rewind_protect.value = round_protection_value


func _on_Character_health_changed(player_health):
	update_health(player_health)

func update_protection(new_value):
	tween.interpolate_property(self, "animated_protection", animated_protection, new_value, 0.6)
	if not tween.is_active():
		tween.start()
	
func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.6)
	if not tween.is_active():
		tween.start()

func _on_Character_died():
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0)


func _on_Character_protection_changed(player_protection):
	update_protection(player_protection) # Replace with function body.
