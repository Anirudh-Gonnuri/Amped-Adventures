extends Camera2D

@export var upper_limit_right = 100000000  # Right limit for the upper part
@export var lower_limit_right = 100000000  # Right limit for the lower part
@export var switch_y_position = 2117   # The Y position where the limit should change

func _process(delta):
	if global_position.y > switch_y_position:
		limit_right = lower_limit_right
	else:
		limit_right = upper_limit_right
