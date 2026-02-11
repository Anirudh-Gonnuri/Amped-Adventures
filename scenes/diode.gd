extends Area2D

@export var is_held: bool = false  
var player_ref: Node2D = null  
var slot_ref: Node2D = null  
var is_locked: bool = false
@onready var diode_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	add_to_group("diode")

func _on_body_entered(body):
	if body.is_in_group("player") and not is_held and not is_locked:
		call_deferred("pick_up", body)

func pick_up(player):
	player_ref = player
	is_held = true
	reparent(player_ref)
	position = Vector2(10, -25)
	player_ref.holding_diode = self

func drop():
	if is_held and player_ref:
		is_held = false
		call_deferred("detach_from_player")

func detach_from_player():
	reparent(get_tree().get_root())  
	global_position = player_ref.global_position + Vector2(50, 25)  
	player_ref.holding_diode = null  
	player_ref = null  

func _on_area_entered(area: Area2D):
	if area.is_in_group("slot") and not is_held and not slot_ref:
		call_deferred("place_in_slot", area)

func place_in_slot(slot):
	slot_ref = slot
	is_locked = true
	reparent(slot_ref)
	global_position = slot_ref.global_position
	rotation_degrees = 0  
	slot_ref.diode = self
	diode_sprite.animation = "placed"
	print("Diode placed in slot! Rotate it to the correct angle.")

func _process(_delta):
	if slot_ref:  # Ensure slot_ref is assigned
		if Input.is_action_just_pressed("rotate"):
			print(" Rotating Diode!")  # Debug
			rotation_degrees += 90
			slot_ref.call_deferred("check_rotation")  # Ensure correct placement
