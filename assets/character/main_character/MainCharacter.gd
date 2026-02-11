extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -800.0

@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D2
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var death = false
var health: int = 100 

var holding_diode: Node2D = null
var holding_resistor: Area2D = null

func _ready():
	PlayerManager.player_died_signal.connect(_on_player_died)
	add_to_group("player")
	PlayerManager.player = self
	name = PlayerManager.player_name
	$hitbox.add_to_group("player_attack")

func _process(_delta):
	if holding_diode and Input.is_action_pressed("drop"):
		holding_diode.drop()
		holding_diode = null
	if Input.is_action_just_pressed("drop") and holding_resistor:
		holding_resistor.drop()
		holding_resistor = null

func _physics_process(delta: float) -> void:
	if death:
		sprite_2d.animation = "death"
		if Input.is_action_pressed("respawn"):
			print("flaggg")
			get_tree().reload_current_scene()
		return

	# Attack logic
	if Input.is_action_pressed("attack"):
		sprite_2d.animation = "attack"
		hitbox.disabled = not (sprite_2d.frame in [5, 6, 9])
	else:
		hitbox.disabled = true

		# Set movement animations
		if velocity.y != 0:
			sprite_2d.animation = "jumping"
		elif velocity.x != 0:
			sprite_2d.animation = "running"
		else:
			sprite_2d.animation = "default"

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 3

	# Movement
	var direction := Input.get_axis("left", "right")
	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, 30)

	# Flip sprite + hitbox
	if direction:
		sprite_2d.flip_h = direction < 0
		hitbox.position.x = -abs(hitbox.position.x) if sprite_2d.flip_h else abs(hitbox.position.x)

	move_and_slide()

func take_damage(amount: int):
	if death:
		return
	health -= amount
	GameManager.decrease_health()
	print("Player took ", amount, "damage. Health:", health)

	if health <= 0:
		_on_player_died()

# Handles death
func _on_player_died():
	death = true
	sprite_2d.animation = "death"
	
