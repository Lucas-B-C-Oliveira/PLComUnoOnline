extends TextureRect


var card_data: CardData



func set_top(card_data) -> void:
	self.card_data = card_data

	texture = load("res://assets/cards/" + card_data.to_text() + ".png")
