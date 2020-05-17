extends Node


var card_pre: Resource = load("res://src/Card/Card.tscn")

var cards_data = []



func reload():

	for c in get_children():
		c.queue_free()
	
	for c in cards_data:

		var card = card_pre.instance()
		card.set_data(c)
		add_child(card)
	