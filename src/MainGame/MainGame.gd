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

	FirestoreListener.set_listener("rooms", GameState.room_name, self, "on_snapshot_data")

	card_manager = load("res://src/Card/CardManager.gd").new()
	# print(card_manager.gen_deck().size()) ## TODO: This line is for verify quantity of cards in deck -> For DEBUG!
	
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
					"stack": {"stringValue": ""}
				}
			}
		}

		## TODO: Claro, arrancar este código! Esse é o jeito que o cara do curso fez! -> Obviamente, não funcionou!
		# room_data["game"] = {}
		# room_data["game"]["way"] = 1
		# room_data["game"]["turn"] = 0
		# room_data["game"]["ncards"] = {}
		# room_data["game"]["state"] = "init"
		# room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.gen_deck())
		# room_data["game"]["stack"] = {}

		Firebase.update_document("rooms/%s" % GameState.room_name, room_info, http)


func on_snapshot_data(data) -> void:
	room_data = data

	if !room_data.has("game"): return

	if is_my_turn():

		if room_data.game.mapValue.fields.state.stringValue == "init":
			if hand.cards_data.size() != 0:
				## TODO: Já comprei as 7 cartas!
				pass
			else:
				card_manager.buy_cards(hand.cards_data, 7)
				calc_next()
				Firebase.update_document("rooms/%s" % GameState.room_name, room_data, http)




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
	var way = int(room_data.game.mapValue.fields.way.integerValue)
	var next = int(room_data.game.mapValue.fields.turn.integerValue)

	for i in range(4):
		next = next + way
		
		if next == 4: next = 0
		if next == -1: next = 3
		
		if room_data.players.mapValue.fields.has(str(next)):
			room_data.game.mapValue.fields.turn.integerValue = next
