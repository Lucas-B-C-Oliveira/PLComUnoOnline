extends TextureRect


var card_data

var card_color



func set_top(card_data) -> void:
	self.card_data = card_data

	texture = load("res://assets/cards/" + card_data.to_text() + ".png")


func can_drop_data(position, data):

	if data.get_name() == "deck": return

	if not get_parent().is_my_turn(): return

	data = data.card_data ## TODO: data é a carta, mas com o data.card_data vira apenas o objeto carta

	if card_data.type == "plus2" and card_data.used != -1:
		if data.type == "plus2":
			data.used = card_data.used + 2
			return true
		else:
			return false
	if data.type == "plus4" or data.type == "jokey":
		return true

	return data.color == card_data.color or data.type == card_data.type


func drop_data(position: Vector2, card) -> void:
	set_top(card.card_data) 

	if card_data.type == "plus4" or card_data.type == "jokey":
		$Red.show()
		$Yellow.show()
		$Green.show()
		$Blue.show()
		card_color = card
	else:
		get_node("../Hand").play_card(card)


func color_selected(color):
	card_color.card_data.color = color
	card_data = card_color.card_data
	texture = load("res://assets/cards/" + card_data.to_string() + ".png")

	$Red.hide()
	$Yellow.hide()
	$Green.hide()
	$Blue.hide()

	get_node("../Hand").play_card(card_color)
	


func _on_Red_pressed() -> void:
	color_selected(1)
	print("_________________REDDD__________________")


func _on_Yellow_pressed() -> void:
	color_selected(2)


func _on_Green_pressed() -> void:
	color_selected(3)


func _on_Blue_pressed() -> void:
	color_selected(4)
