extends Control

@onready var fade_overlay = $FadeOverlay

func _ready():
	# Start fully black (make sure this is also set in the Inspector)
	fade_out_from_black()

func fade_out_from_black():
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
