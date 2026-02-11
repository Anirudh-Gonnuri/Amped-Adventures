extends Node

@onready var ui_node: Node = null
var health = 10
var attack_inst = false
var resistor_hint_visible := false

func _ready():

	get_tree().root.child_entered_tree.connect(_on_child_entered)

func _on_child_entered(node: Node) -> void:
	
	if node == get_tree().current_scene:
		await get_tree().process_frame
		ui_node = node.find_child("UI", true, false)

# Health logic
func decrease_health():
	health -= 1
	print("Health: ", health)
	if not ui_node:
		print("ui not found")
		return
	var hearts_container = ui_node.find_child("hearts", true, false)
	if not hearts_container:
		print("hearts not found")
		return

	var hearts = hearts_container.get_children()
	for h in 3:
		if h < health:
			hearts[h].show()
		else:
			hearts[h].hide()

	if health == 0:
		PlayerManager.player_died()

# Deathbox logic
func _on_deadbox_body_entered(body: Node2D) -> void:
	if body.name == PlayerManager.player_name:
		PlayerManager.player_died()

# Attack instruction logic
func display_attack():
	if ui_node:
		var instruction_ui = ui_node.get_node_or_null("Instructions")
		if instruction_ui:
			instruction_ui.show_attack_instruction()

func show_diode_help():
	if ui_node:
		var instruction_ui = ui_node.get_node_or_null("Instructions")
		if instruction_ui:
			instruction_ui.show_diode_instruction()
			
func toggle_resistor_instruction():
	if ui_node:
		var resistor_image=ui_node.get_node("ResistorImage")
		if resistor_image and not resistor_image.visible:
			resistor_image.visible = true
			await get_tree().create_timer(6).timeout
			resistor_image.visible = false
			custom_message("Press Q to drop")
		
# Custom messages
func custom_message(message: String) -> void:
	if ui_node:
		var instruction_ui = ui_node.get_node_or_null("Instructions")
		if instruction_ui:
			instruction_ui.show_custom_instruction(message)

# Door / level change
func _on_door_signal_body_entered(body: Node2D) -> void:
	if body.name == PlayerManager.player_name:
		print("Player entered door! Loading next level...")
		if ResourceLoader.exists("res://scenes/level2.tscn"):
			get_tree().change_scene_to_file("res://scenes/level2.tscn")
