extends Area2D

@export_enum("intro", "resistor", "diode") var help_type: String = "intro"
var triggered: bool = false

func _on_body_entered(body):
	if body.is_in_group("player") and not triggered:
		print("flag")
		triggered = true
		match help_type:
			"intro":
				GameManager.display_attack()
			"resistor":
				GameManager.toggle_resistor_instruction()
			"diode":
				GameManager.show_diode_help()
	
