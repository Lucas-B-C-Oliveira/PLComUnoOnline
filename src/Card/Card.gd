extends Control


var card_data



func set_data(data) -> void:
	card_data = data
	$Texture.texture = load("res://assets/cards/" + card_data.to_text() + ".png")
