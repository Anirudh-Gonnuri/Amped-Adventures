extends Area2D

@export var correct_rotation: float = 180
@export var target_pad: NodePath
var pad: Node = null

var diode: Node2D = null  
var is_correct: bool = false  
@onready var door = get_parent().get_node_or_null("door")

func _ready():
	add_to_group("slot")
	if target_pad != NodePath():
		pad = get_node_or_null(target_pad)

func _on_area_entered(area: Area2D):
	if area.is_in_group("diode") and diode == null and not area.is_held:
		call_deferred("attach_diode", area)

func attach_diode(area):
	diode = area
	diode.place_in_slot(self)

func check_rotation():
	if diode:
		if fmod(diode.rotation_degrees, 360) == correct_rotation:
			is_correct = true
			activate_gate()
			if pad:
				pad.add_power_source(self)
		else:
			is_correct = false
			GameManager.custom_message("Diode is incorrectly placed. Rotate it!")
			if pad:
				pad.remove_power_source(self)

func activate_gate():
	if door:
		door.open_gate()
	GameManager.custom_message("Diode correctly placed! Gate activated!")
