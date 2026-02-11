extends CharacterBody2D

@onready var sight_line: Area2D = %Sight_line
@onready var left_check: RayCast2D = $Left_check
@onready var right_check: RayCast2D = $Right_check
@onready var front_check: RayCast2D = $Front_check
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sight_box: CollisionShape2D = $Sight_line/CollisionShape2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $AttackCooldownTimer

@export var speed: float = 60.0
@export var chase_speed: float = 100.0
@export var gravity: float = 500.0
@export var damage: int = 10
@export var attack_cooldown: float = 1.0

var direction: int = 1
var is_chasing: bool = false
var can_attack: bool = true
var dead: bool = false
var health: int = 20


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta  # Gravity

	if dead:
		velocity.x = 0
	elif sprite_2d.animation == "attack":
		velocity.x = 0
	elif is_chasing:
		chase_player()
	else:
		patrol()

	move_and_slide()

# Patrol logic
func patrol():
	var is_blocked = (
		(not left_check.is_colliding() and direction == -1) or 
		(not right_check.is_colliding() and direction == 1) or 
		(front_check and front_check.is_colliding())
	)

	if is_blocked:
		flip_direction()

	velocity.x = direction * speed

	if abs(velocity.x) > 1:
		sprite_2d.play("walking")

# Flip direction
func flip_direction():
	direction *= -1
	sprite_2d.flip_h = not sprite_2d.flip_h
	sight_box.position.x = -sight_box.position.x
	front_check.target_position.x = -front_check.target_position.x
	attack_area.position.x = -attack_area.position.x

# Chase logic
func chase_player():
	var player_pos: Vector2 = PlayerManager.player.global_position
	var player_direction = (player_pos - global_position).normalized()
	velocity.x = player_direction.x * chase_speed
	sprite_2d.play("walking")

# Detect attack collision
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == PlayerManager.player_name and can_attack and not dead:
		attack(body)

# Damage logic
func attack(player: Node2D) -> void:
	can_attack = false
	sprite_2d.play("attack")
	if player.has_method("take_damage"):
		player.take_damage(damage)
	attack_timer.start(attack_cooldown)
	
# Handle player attacking enemy
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		take_damage(10)

func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy Health:", health)
	if health <= 0:
		die()

func die():
	dead = true
	sprite_2d.play("death")
	await sprite_2d.animation_finished
	queue_free()

# Start/stop chasing
func _on_sight_line_body_entered(body: Node2D) -> void:
	if body.name == PlayerManager.player_name:
		is_chasing = true

func _on_sight_line_body_exited(body: Node2D) -> void:
	if body.name == PlayerManager.player_name:
		is_chasing = false


func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true
