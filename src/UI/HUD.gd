extends MarginContainer

onready var player_number_label = $Bars/Lifebar/Bar/Count/Background/Number
onready var player_bar = $Bars/Lifebar/Bar/Gauge
onready var tween = $Tween
var player_old_health = 0
onready var player = $"../../Level/Player"

func _ready():
	player_old_health = player.current_health
	player_bar.max_value = player.max_health
	update_health()
	player.connect("health_changed", self, "_on_player_health_changed")

func update_health():
	player_number_label.text = str(player_bar.value)
	animate_bar(player_old_health, player.current_health)
	player_old_health = player.current_health

func animate_bar(old_health, new_health):
	tween.interpolate_property(player_bar, ":value", old_health, new_health, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	if not tween.is_active():
		tween.start()

func _on_player_health_changed():
	print("caught signal player health changed")
	update_health()
