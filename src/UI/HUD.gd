extends MarginContainer

onready var health_number_label = $Bars/Lifebar/Bar/Count/Background/Number
onready var health_bar = $Bars/Lifebar/Bar/Gauge
onready var tween = $Tween
var actor_old_health = 0
onready var actor = $"../../Level/Player"

func _ready():
	actor_old_health = actor.current_health
	health_bar.max_value = actor.max_health
	update_health()
	actor.connect("health_changed", self, "_on_health_changed")

func update_health():
	health_number_label.text = str(health_bar.value)
	animate_bar(actor_old_health, actor.current_health)
	actor_old_health = actor.current_health

func animate_bar(old_health, new_health):
	tween.interpolate_property(health_bar, ":value", old_health, new_health, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	if not tween.is_active():
		tween.start()

func _on_health_changed():
	print("caught signal player health changed")
	update_health()
