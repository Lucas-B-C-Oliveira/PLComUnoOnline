extends Node
class_name InstanceManager


export(Resource) var loader_res: Resource = load("res://src/Loader/Loader.tscn")



func _ready() -> void:
	SignalManager.connect(SignalManager.SIGNAL_GAME_LOADED, self, "instantiate_game")
	instantiate_loader()


func instantiate_loader() -> void:
	self.add_child(loader_res.instance())


func instantiate_game(game) -> void:
	print("instantiate -> game: ", game)
	self.get_node("Game").add_child(game)
	pass
