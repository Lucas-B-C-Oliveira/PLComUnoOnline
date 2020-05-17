extends Control


func _ready() -> void:
	$Panel/Name.text = str(GameState.room_data.game.mapValue.fields.winner.stringValue)


func _on_Exit_pressed() -> void:
	get_tree().change_scene("res://src/HostAndJoin/HostAndJoin.tscn")