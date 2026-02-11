extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var sprite: Sprite2D = $doorsprite

func open_gate():
	print("Gate opening...")
	fade_out()
	await get_tree().create_timer(1.5).timeout 
	collision.set_deferred("disabled", true)  # Remove collision so player can pass

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 5)  # Fade out over 1.5 seconds
	await tween.finished
	sprite.visible = false  # Hide after fading out
