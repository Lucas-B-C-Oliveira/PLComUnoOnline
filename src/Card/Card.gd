extends Control


var card_pre = load("res://src/Card/Card.tscn")
var card_data



func set_data(data) -> void:
	card_data = data
	$Texture.texture = load("res://assets/cards/" + card_data.to_text() + ".png")


func get_drag_data(position: Vector2):
	var card = card_pre.instance()
	card.set_data(card_data)
	card.get_node("Texture").set_position(Vector2(-111/2, -169/2))
	set_drag_preview(card)
	return self