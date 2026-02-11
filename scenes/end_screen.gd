extends Control

# Reference to the Tween node
# Fade duration in seconds
var fade_duration: float = 1.0
@onready var end_text: Label = $end_text
@onready var timer: Timer = $Timer
@onready var background: ColorRect = $background


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure the death screen is fully transparent at the start
	self.modulate.a = 0.0
	self.visible = false
	
# Function to show the death screen with a fade-in effect
func show_end_screen():
	# Make the death screen visible
	self.visible = true
	var fade_tween = create_tween()
	# Animate the alpha from 0 (transparent) to 1 (opaque)
	fade_tween.tween_property(self, "modulate:a", 1.0, fade_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	blink_end_label()



func blink_end_label():
	# Create a tween for the restart label's opacity
	var restart_tween = create_tween()
	# First tween fades in the restart label
	restart_tween.tween_property(end_text, "modulate:a", 1.0, fade_duration)
	# Second tween fades out the restart label
	restart_tween.tween_property(end_text, "modulate:a", 0.0, fade_duration)
	# Loop the tween to create a blinking effect
	restart_tween.set_loops() # Set the repeat for the blink effe


func _on_door_signal_body_entered(body: Node2D) -> void:
	show_end_screen()
