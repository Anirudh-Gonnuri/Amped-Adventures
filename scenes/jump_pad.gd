extends Area2D

@export var active_texture: Texture
@export var inactive_texture: Texture
@export var jump_power: int 

var is_active := false
var active_sources: Array = []  # Tracks who is powering the pad

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = inactive_texture

func add_power_source(source: Node):
	if source not in active_sources:
		active_sources.append(source)
		update_activation_state()

func remove_power_source(source: Node):
	active_sources.erase(source)
	update_activation_state()

func update_activation_state():
	if active_sources.size() > 0 and not is_active:
		activate()
	elif active_sources.size() == 0 and is_active:
		deactivate()

func activate():
	is_active = true
	sprite.texture = active_texture
	print("Jump Pad Activated!")

func deactivate():
	is_active = false
	sprite.texture = inactive_texture
	print("Jump Pad Deactivated!")

func _on_body_entered(body):
	if is_active and body.is_in_group("player"):
		body.velocity.y = -jump_power
		print("Player Jumped!")
