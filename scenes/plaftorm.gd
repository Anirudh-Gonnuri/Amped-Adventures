extends CharacterBody2D

@export var speed: float = 100.0  # Speed of the platform
var direction: int = 1  # 1 = Right, -1 = Left
var previous_position: Vector2  # Stores the last position

func _ready():
	previous_position = position  # Initialize previous position

func _physics_process(delta: float) -> void:
	delta = delta
	velocity.x = speed * direction
	move_and_slide()

	# Check if the platform is stuck (wall collision)
	if position.x == previous_position.x:
		direction *= -1  # Reverse direction

	# Update previous position for next frame
	previous_position = position
