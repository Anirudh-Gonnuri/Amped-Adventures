extends Control

@onready var fade_overlay = $Background
@onready var play_button = $VBoxContainer/Play
@onready var quit_button = $VBoxContainer/Exit
@onready var ui_container = $VBoxContainer

var fade_alpha := 1.0 

func _ready():
	# Force overlay to black right away
	set_fade_alpha(fade_alpha)

	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	ui_container.visible = false
	fade_out_and_start_game()

func _on_quit_pressed():
	get_tree().quit()

func fade_out_and_start_game():
	var tween = create_tween()
	tween.tween_property(self, "fade_alpha", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(self, "_on_fade_out_finished"))

func _on_fade_out_finished():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func set_fade_alpha(value: float) -> void:
	fade_alpha = value
	var color = fade_overlay.modulate
	color.a = fade_alpha
	fade_overlay.modulate = color
