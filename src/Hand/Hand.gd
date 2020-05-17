extends Node


var card_pre: Resource = load("res://src/Card/Card.tscn")

var cards_data = []



func reload() -> void:

	for c in get_children():
		c.queue_free()
	
	# Para cada carta na mão
	for c in range(cards_data.size()):
		# Adiciona a carta à mão
		var card = card_pre.instance()
		card.set_data(cards_data[c])
		add_child(card)


func play_card(card) -> void:

	cards_data.remove(cards_data.find(card.card_data))
	remove_child(card)

	if card.card_data.type == "block" and card.card_data.used != -1: ## EFEITO DO BLOCK | CANCEL | VETO!
		card.card_data.used = -1
		get_parent().calc_next()
	
	get_parent().card_manager.stack.append(card.card_data)
	
	get_parent().go_to_next()


# Verifica se pode soltar objeto
func can_drop_data(pos, data):
	# Só pode soltar se o objeto for do deck
	return data.get_name() == "deck"

# Solicita compra de carta
func drop_data(pos, card):
	buy_card()

# Solicita compra de carta
func buy_card():
	get_parent().buy_card()