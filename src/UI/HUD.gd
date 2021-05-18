extends MarginContainer

onready var player_number_label = $Bars/Lifebar/Bar/Count/Background/Number
onready var player_bar = $Bars/Lifebar/Bar/Gauge
onready var tween = $Tween
var animated_player_health = 0

func _ready():
	var player_max_health = $"../Level/Player".max_health
	player_bar.max_value = player_max_health
	update_health(player_max_health, "player")
#
func get_animated_health(character):
	return animated_player_health
#
func update_health(new_value, character):
	var animated_health = get_animated_health(character)
	tween.interpolate_property(self, "animated_" + character + "_health", animated_health, max(new_value, 0), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()
