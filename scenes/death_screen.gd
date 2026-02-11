extends Control

# Reference to the Tween node
# Fade duration in seconds
var fade_duration: float = 1.0
@onready var restart_label: Label = $RestartText
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure the death screen is fully transparent at the start
	self.modulate.a = 0.0
	self.visible = false
	
	# Connect the player death signal
	PlayerManager.player_died_signal.connect(show_death_screen)
	
# Function to show the death screen with a fade-in effect
func show_death_screen():
	# Make the death screen visible
	self.visible = true
	var fade_tween = create_tween()
	# Animate the alpha from 0 (transparent) to 1 (opaque)
	fade_tween.tween_property(self, "modulate:a", 1.0, fade_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	blink_restart_label()
# Function to hide the death screen with a fade-out effect
func hide_death_screen():
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, fade_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	# Hide the death screen after the fade-out animation completes
	fade_tween.finished.connect(_on_fade_out_completed)
	
# Called when the fade-out animation completes
func _on_fade_out_completed():
	# Hide the death screen after the fade-out animation
	self.visible = false

func blink_restart_label():
	# Create a tween for the restart label's opacity
	var restart_tween = create_tween()
	# First tween fades in the restart label
	restart_tween.tween_property(restart_label, "modulate:a", 1.0, fade_duration)
	# Second tween fades out the restart label
	restart_tween.tween_property(restart_label, "modulate:a", 0.0, fade_duration)
	# Loop the tween to create a blinking effect
	restart_tween.set_loops() # Set the repeat for the blink effect

# In DeathScreen script
func _process(_delta):
	if Input.is_action_just_pressed("respawn"):
		hide_death_screen()
		
