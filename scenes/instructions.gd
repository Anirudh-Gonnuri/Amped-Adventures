extends Control

@onready var s_key: AnimatedSprite2D = $SKey
@onready var w_key: AnimatedSprite2D = $WKey
@onready var a_key: AnimatedSprite2D = $AKey
@onready var d_key: AnimatedSprite2D = $DKey
@onready var e_key: AnimatedSprite2D = $EKey
@onready var big: TextureRect = $Big
@onready var attack: Label = $Attack
@onready var continue_label: Label = $Continue
@onready var lore: Label = $Lore

# Constants
const FADE_DURATION = 0.5
const TYPE_SPEED = 0.05

var tutorial_active = false  # Tracks if any tutorial is running

func _ready():
	modulate.a = 0.0
	visible = false

	# Start movement tutorial automatically
	show_movement_instruction()

# Fade helpers
func fade_in():
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, FADE_DURATION)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_DURATION)
	await tween.finished
	visible = false
	tutorial_active = false  # Tutorial is over

# Show movement tutorial
func show_movement_instruction():
	_toggle_groups("movement")
	fade_in()
	await get_tree().create_timer(3.0).timeout
	fade_out()

# Show attack tutorial (Call this manually when needed)
func show_attack_instruction():
	if tutorial_active:
		return
	tutorial_active = true
	get_tree().paused = true
	_toggle_groups("lore")
	fade_in()
	
	await typewriter_effect("Enemies will kill you", lore)
	await wait_for_continue()
	
	get_tree().paused = true
	_toggle_groups("attack")
	fade_in()

	
	await wait_for_continue()

	get_tree().paused = false
	fade_out()
	
func show_diode_instruction():
	if tutorial_active:
		return
	tutorial_active = true

	get_tree().paused = true
	_toggle_groups("lore")
	fade_in()

	await typewriter_effect("Infront of you is a diode, it will allow flow of electricity in only one direction", lore)
	await wait_for_continue()

	get_tree().paused = false
	fade_out()

func show_puzzle_instruction():
	if tutorial_active:
		return
	tutorial_active = true

	get_tree().paused = true
	_toggle_groups("lore")
	fade_in()

	await typewriter_effect("Solve the puzzle by placing the correct resistor.", lore)
	await wait_for_continue()

	get_tree().paused = false
	fade_out()

func show_custom_instruction(message: String)-> void:
	if tutorial_active:
		return
	tutorial_active = true

	_toggle_groups("lore")
	fade_in()
	
	await typewriter_effect(message, lore)
	await get_tree().create_timer(0.6).timeout
	fade_out()
	
# Wait until the player presses "F"
func wait_for_continue():
	continue_label.visible = true
	await typewriter_effect("Press F to Continue", continue_label)
	await wait_for_input("continue")
	continue_label.visible = false

# Handle key animations
func _process(_delta):
	var key_map = {
		"jump": w_key, "left": a_key, "down": s_key, "right": d_key, "attack": e_key
	}

	for action in key_map.keys():
		var key_sprite = key_map[action]
		if key_sprite:
			handle_key_press(action, key_sprite)

# Handle key press animations
func handle_key_press(action, key_sprite):	
	if Input.is_action_pressed(action):
		key_sprite.play("pressed")
	else:
		key_sprite.play("default")

# Typewriter effect
func typewriter_effect(full_text: String, label):
	label.text = ""
	for ch in full_text:
		label.text += ch
		await get_tree().create_timer(TYPE_SPEED).timeout

# Toggle UI groups visibility
func _toggle_groups(active_group: String):
	for group in ["movement", "lore", "attack"]:
		get_tree().call_group(group, "set_visible", group == active_group)

# Wait for a specific key input
func wait_for_input(action: String):
	await get_tree().process_frame  # Ensure it doesn't register instantly
	while not Input.is_action_just_pressed(action):
		await get_tree().process_frame
