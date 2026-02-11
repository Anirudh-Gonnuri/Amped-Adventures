extends Area2D

@export var resistor_value: int = 100 
@export var resistor_texture: Texture 

@onready var sprite: Sprite2D = $Sprite2d

var is_held: bool = false  
var player_ref: Node2D = null  
var slot_ref: Node2D = null  
var is_locked: bool = false  

func _ready():
	add_to_group("resistor")
	sprite.texture = resistor_texture

func _on_body_entered(body):
	if body.is_in_group("player") and not is_held and not is_locked:
		if slot_ref and slot_ref.correct_resistor_value == resistor_value:
			print("Correct resistor placed, cannot pick up!")
			return  
		
		if body.holding_resistor == null:
			call_deferred("pick_up", body)

func pick_up(player):
	player_ref = player
	is_held = true
	reparent(player_ref)
	position = Vector2(10, -25)
	player_ref.holding_resistor = self

func drop():
	if is_held and player_ref:
		is_held = false
		call_deferred("detach_from_player")

func detach_from_player():
	reparent(get_tree().get_root())  
	global_position = player_ref.global_position + Vector2(50, 25)  
	player_ref.holding_resistor = null  
	player_ref = null  

func _on_area_entered(area: Area2D):
	if area.is_in_group("socket") and not is_held and not slot_ref:
		call_deferred("place_in_socket", area)

func place_in_socket(socket):
	slot_ref = socket
	is_locked = true
	reparent(slot_ref)
	global_position = slot_ref.global_position
	rotation_degrees = 0  
	slot_ref.resistor = self
	print("Resistor placed in socket!")
	socket.call_deferred("check_resistor")
