extends Control

# References to the AnimatedSprite2D nodes for each key
@onready var w_key = $WKey
@onready var timer = $DisappearTimer
func _ready():
	# Start the timer when the scene loads
	timer.start()

	# Ensure the panel is visible at the start
	self.visible = true

	# Reset all keys to the default state
	reset_keys()

func _process(delta):
	# Check for key presses and switch to the pressed animation
	handle_key_press("ui_up", w_key)

func handle_key_press(action, key_sprite):
	if Input.is_action_pressed(action):
		key_sprite.play("Pressed")  # Play the pressed animation
	else:
		key_sprite.play("Default")  # Play the default animation

func reset_keys():
	# Reset all keys to the default state
	w_key.play("Default")

func _on_disappear_timer_timeout():
	# Hide the panel when the timer runs out
	self.visible = false
