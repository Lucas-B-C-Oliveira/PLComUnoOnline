extends Control


signal signal_play_button_pressed_in_HostGame
signal signal_cancel_button_pressed_in_HostGame

var user_data
var room_data
enum { CREATE, WAIT, START }
var state = CREATE
var room_info := {
	"players": {},
	"state": {},
} setget set_room_info

onready var info: Label = $Container/Info
onready var notification: Label = $Container/Notification
onready var host_name_label: Label = $Container/HostName
onready var number_of_players_label: Label = $Container/NumberOfPlayers
onready var http: HTTPRequest = $HTTPRequest
onready var play_button: Button = $Container/VBoxContainer2/Play



func play_host_game() -> void:
	GameState.host = true
	GameState.my_number_in_room = 0
	GameState.room_name = GameState.user_name


	info.text = "Criando Sala..." ## TODO: Fazer isso com uma animação!

	room_info.state = { "stringValue": "open"}
	room_info.players =  {"mapValue": {"fields": {"0": {"stringValue": GameState.room_name}}}}

	Firebase.save_document("rooms?documentId=%s" % GameState.room_name, room_info, http)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:

	if state == CREATE:

		var response_body := JSON.parse(body.get_string_from_ascii())

		if response_code == 409:
			Firebase.update_document("rooms/%s" % GameState.room_name, room_info, http)
		elif response_code == 200:
			info.text = "Seus amigos devem dar Join em:"
			host_name_label.text = GameState.room_name
			FirestoreListener.set_listener("rooms", GameState.room_name, self, "on_snapshot_data")
			state = WAIT
		else:
			notification.text = response_body.result.error.message.capitalize()



func on_snapshot_data(data) -> void:

	room_data = data

	if state == WAIT:

		var number_of_players: int = room_data.players.mapValue.fields.size()

		number_of_players_label.text = "Players ( " + str(number_of_players) + "/4 ):"

		# print("room_data: ", room_data.players.mapValue.fields["0"].stringValue)

		 # TODO: Eu acho que tem que transformar em JSON, json_parse, sei lá, algo assim, para acessar os valores do dicionário!
		 # TODO: Concordo!!

		for i in range(4):

			if room_data.players.mapValue.fields.has(str(i)):

				get_node("Container/Player" + str(i)).text = room_data.players.mapValue.fields[str(i)].stringValue

			else:
				get_node("Container/Player" + str(i)).text = "-"
		
				play_button.disabled = (number_of_players <= 1)

	elif room_data.state.stringValue == "start" == START:
		GameState.room_data = room_data
		get_tree().change_scene("res://src/MainGame/MainGame.tscn")


func _on_Play_pressed() -> void:

	# emit_signal("signal_play_button_pressed_in_HostGame")

	room_data.state.stringValue = "start"

	Firebase.update_document("rooms/%s" % GameState.room_name, room_data, http)

	print("room_data.state: ", room_data.state.stringValue)

	state = START
	


func _on_Cancel_pressed() -> void:

	emit_signal("signal_cancel_button_pressed_in_HostGame")

	room_data.state.stringValue = "cancel"

	Firebase.update_document("rooms/%s" % GameState.room_name, room_data, http)



func connect_signals_with(gm_ref, func_name: String = "", func_name2: String = "") -> void:

	if gm_ref.has_method(func_name) and !is_connected("signal_play_button_pressed_in_HostGame", gm_ref, func_name):
	
		connect("signal_play_button_pressed_in_HostGame", gm_ref, func_name)
	
	if gm_ref.has_method(func_name) and !is_connected("signal_cancel_button_pressed_in_HostGame", gm_ref, func_name2):

		connect("signal_cancel_button_pressed_in_HostGame", gm_ref, func_name2)


func set_room_info(value: Dictionary) -> void:
	pass
