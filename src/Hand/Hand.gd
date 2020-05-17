extends Node


var card_pre: Resource = load("res://src/Card/Card.tscn")

var cards_data = []



func reload() -> void:

	for c in get_children():
		c.queue_free()
	
	for c in cards_data:

		var card = card_pre.instance()
		card.set_data(c)
		add_child(card)


func play_card(card):
	cards_data.remove(cards_data.find(card.card_data))
	remove_child(card)

	if card.card_data.type == "block" and card.card_data.used != -1: ## EFEITO DO BLOCK | CANCEL | VETO!
		card.card_data.used = -1
		get_parent().calc_next()
	
	get_parent().go_to_next()


func can_drop_data(position, data):
	buy_card()


func buy_card():
	get_parent().buy_card()