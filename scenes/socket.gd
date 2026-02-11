extends Area2D

@export var correct_resistor_value: int
@export var target_pad: NodePath 
var pad: Node = null

var placed_resistor = null

func _ready():
	add_to_group("slot")
	if target_pad != NodePath():
		pad = get_node_or_null(target_pad)

func place_resistor(resistor):
	if placed_resistor == null:
		placed_resistor = resistor
		resistor.reparent(self)
		resistor.global_position = global_position
		print("Resistor placed: ", resistor.resistor_value)

		if resistor.resistor_value == correct_resistor_value:
			if pad:
				pad.add_power_source(self)
			disable_resistor_interaction(resistor)
			print("Correct resistor placed! Resistor is now locked.")
		else:
			print("Incorrect Resistor! Remove and try again.")
			if pad:
				pad.remove_power_source(self)  # Optional: deactivate on wrong resistor

func remove_resistor():
	if placed_resistor:
		enable_resistor_interaction(placed_resistor)

		if pad:
			pad.remove_power_source(self)

		placed_resistor.reparent(get_tree().get_root())
		placed_resistor = null
		print("Resistor removed. Try again.")

func _on_area_entered(area):
	if area.is_in_group("resistor"):
		if placed_resistor and placed_resistor != area:
			remove_resistor()
		place_resistor(area)

func disable_resistor_interaction(resistor):
	resistor.set_deferred("monitoring", false)
	resistor.set_deferred("monitorable", false)

	var collision_shape = resistor.get_node_or_null("CollisionShape2D")
	if collision_shape:
		collision_shape.set_deferred("disabled", true)

func enable_resistor_interaction(resistor):
	resistor.set_deferred("monitoring", true)
	resistor.set_deferred("monitorable", true)

	var collision_shape = resistor.get_node_or_null("CollisionShape2D")
	if collision_shape:
		collision_shape.set_deferred("disabled", false)
