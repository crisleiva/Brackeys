extends MarginContainer
onready var number = $HBoxContainer/bars/bar/Count/Background/Number
onready var health_bar = $HBoxContainer/bars/bar/LifeGauge
onready var rewind_protect = $HBoxContainer/bars/bar/RewindGauge
onready var tween = $Tween
var animated_health = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var players_max_health = get_parent().get_parent().get_parent().max_health
	health_bar.max_value = players_max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var round_value = round(animated_health)
	number.text = str(round_value)
	health_bar.value = round_value


func _on_Character_health_changed(player_health):
	update_health(player_health)

func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.6)
	if not tween.is_active():
		tween.start()

func _on_Character_died():
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0)
