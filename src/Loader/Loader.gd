extends Control

export(Resource) var game_res: Resource = load("res://src/GameManager/GameManager.tscn")



func _ready() -> void:
	game_loaded(game_res)


func game_loaded(game_to_instance) -> void:
	var game_ref = game_to_instance.instance()
	print("game_loaded | game_ref: ", game_ref)
	SignalManager.emit_signal(SignalManager.SIGNAL_GAME_LOADED, game_ref)