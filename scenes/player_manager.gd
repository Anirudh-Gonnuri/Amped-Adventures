extends Node

var player_name = "Jose"
var player: CharacterBody2D = null
signal player_died_signal

func player_died():
	print("player died")
	player_died_signal.emit()
 # Global reference to the player

func _ready() -> void:
	await get_tree().process_frame  # ensure all nodes are initialized
	_find_player() 
	
func _find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assign the first player found
	else:
		player = null
