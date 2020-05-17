extends Control


var my_number_in_room
var room_data
var room_info := {
	"game": {},
	"players": {},
	"state": {},
}

var card_manager

onready var http: HTTPRequest = $HTTPRequest
onready var hand: BoxContainer = $Hand



func _ready() -> void:

	room_data = GameState.room_data
	my_number_in_room = GameState.my_number_in_room


	card_manager = load("res://src/Card/CardManager.gd").new()
	
	show_profiles()

	if GameState.host:

		room_info.state.stringValue = room_data.state.stringValue
		room_info.players = room_data.players

		var dic_deck: Dictionary = card_manager.array_to_dic(card_manager.gen_deck())
		
		room_info.game = {
		"mapValue": 
			{"fields": 
				{
					"way": {"integerValue": 1},
					"turn": {"integerValue": 0},
					"ncards": {"integerValue": 0},
					"state": {"stringValue": "init"},
					"deck": {"mapValue": {"fields": dic_deck}},
					"stack": {"stringValue": ""},
					"top_card": {"stringValue": ""}
				}
			}
		}
		Firebase.update_document("rooms/%s" % GameState.room_name, room_info, http)

	FirestoreListener.set_listener("rooms", GameState.room_name, self, "on_snapshot_data")
	


func on_snapshot_data(data) -> void:
	room_data = data

	if !room_data.has("game"): return

	if room_data.game.mapValue.fields.state.stringValue == "normal":
		var card_top_now = card_manager.to_card_data(room_data.game.mapValue.fields.top_card.stringValue)
		$Stack.set_top(card_top_now)

		## Se é minha vez e se não é minha vez!!!


	if is_my_turn():

		if room_data.game.mapValue.fields.state.stringValue == "init":

			card_manager.update_deck(room_data.game.mapValue.fields.deck.mapValue.fields)

			if hand.cards_data.size() != 0:

				room_data.game.mapValue.fields.state.stringValue = "normal"
				var first_card = card_manager.get_random_card(true)
				room_data.game.mapValue.fields.top_card.stringValue = first_card.to_string()
				var dic_deck: Dictionary = card_manager.array_to_dic(card_manager.deck) 
				room_data.game.mapValue.fields.deck.mapValue.fields = dic_deck ## UPDATE DECK
				Firebase.update_document("rooms/%s" % GameState.room_name, room_data, http)

			else:

				card_manager.buy_cards(hand.cards_data, 7)
				hand.reload()
				calc_next()
				var dic_deck: Dictionary = card_manager.array_to_dic(card_manager.deck)
				room_data.game.mapValue.fields.deck.mapValue.fields = dic_deck ## UPDATE DECK
				Firebase.update_document("rooms/%s" % GameState.room_name, room_data, http)
		
		if room_data.game.mapValue.fields.state.stringValue == "normal":

			card_manager.update_deck(room_data.game.mapValue.fields.deck.mapValue.fields) ## UPDATE DECK

			if $Stack.card_data != null:

				if $Stack.card_data.type == "plus4" and $Stack.card_data.used != -1:

					$Info.text = "Comprou 4!"
					card_manager.buy_cards(hand.cards_data, 4)
					hand.reload()
					$Stack.card_data.used = -1

				elif $Stack.card_data.type == "plus2" and $Stack.card_data.used != -1:
					$Info.text = "Compre " + str($Stack.card_data.used + 2) + "!"

				else:
					$Info.text = "Sua vez!"
				
				highlight()
	else:
		highlight()
		$Info.text = "Aguarde sua vez!"


func is_my_turn() -> bool:
	return int(room_data.game.mapValue.fields.turn.integerValue) == my_number_in_room


func show_profiles():
	var player = my_number_in_room

	for i in range(4):

		if room_data.players.mapValue.fields.has(str(player)):
			## TODO: Verify this function!! 
			get_node("Player" + str(i)).visible = true
			get_node("Player" + str(i) + "/Name").text = room_data.players.mapValue.fields[str(player)].stringValue
		
		player = (player + 1)%4


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:

	var response_body := JSON.parse(body.get_string_from_ascii())

	if response_code != 200:
		print("ERROR: ", response_body.result.error.message.capitalize())


func calc_next():

	if $Stack.card_data != null and $Stack.card_data.type == "reverse" and $Stack.card_data.used != -1: ## REVERSE | INVERTE | EMENDA PARLAMENTAR!
		var new_turn = int(room_data.game.mapValue.fields.way.integerValue) 
		new_turn *= -1
		room_data.game.mapValue.fields.way.integerValue = new_turn
		$Stack.card_data.used = -1


	var way = int(room_data.game.mapValue.fields.way.integerValue)
	var next = int(room_data.game.mapValue.fields.turn.integerValue)

	for i in range(4):
		next = next + way
		
		if next == 4: next = 0
		if next == -1: next = 3
		
		if room_data.players.mapValue.fields.has(str(next)):
			room_data.game.mapValue.fields.turn.integerValue = next


func highlight() -> void:
	
	for i in range(4):
		if i == int(room_data.game.mapValue.fields.turn.integerValue):
			get_node("Player" + str(calc_num_player(i))).self_modulate = Color(1, 0, 0)
		else:
			get_node("Player" + str(calc_num_player(i))).self_modulate = Color(1, 1, 1)


func calc_num_player(p) -> int:
	var r = p - my_number_in_room if p - my_number_in_room >= 0 else 4 + p - my_number_in_room
	return r


func go_to_next() -> void:
	calc_next()
	
	room_data.game.mapValue.fields.ncards.integerValue = hand.cards_data.size()
	var dic_deck: Dictionary = card_manager.array_to_dic(card_manager.deck)
	room_data.game.mapValue.fields.deck.mapValue.fields = dic_deck ## UPDATE DECK
	room_data.game.mapValue.fields.top_card.stringValue = $Stack.card_data.to_string() ## Set Card of TOP!
	Firebase.update_document("rooms/%s" % GameState.room_name, room_data, http)


func buy_card():

	if not is_my_turn(): return

	if $Stack.card_data.type == "plus2" and $Stack.card_data.used != -1:
		card_manager.buy_cards(hand.cards_data, $Stack.card_data.used + 2) ## COMPRA + 2
		$Stack.card_data.used = -1
	else:
		card_manager.buy_cards(hand.cards_data)
	
	hand.reload()
	go_to_next()
