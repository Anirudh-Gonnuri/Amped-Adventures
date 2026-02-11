extends Area2D

@onready var collectible: AnimatedSprite2D = $AnimatedSprite2D
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == PlayerManager.player_name :
		collectible.animation = "collected"
		GameManager.add_points()
		await collectible.animation_finished
		queue_free()
		
