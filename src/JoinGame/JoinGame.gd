extends Control


signal signal_join_button_pressed_in_JoinGame
signal signal_cancel_button_pressed_in_JoinGame

enum { CONNECT, WAIT, CONNECTED}
var state = CONNECT

var room_data
var room_info := {
	"players": {},
	"state": {},
}

onready var host_name: LineEdit = $Container/VBoxContainer3/Username/LineEdit
onready var join_button: Button = $Container/VBoxContainer3/Username/Join
onready var http: HTTPRequest = $HTTPRequest



func play_join_game() -> void:
	GameState.host = false
	
	for i in range(4):
		get_node("Container/Player" + str(i)).text = "-"
			
	join_button.disabled = false
	host_name.editable = true
	host_name.text = ""
	host_name.placeholder_text = "Host Name"
	state = CONNECT

	# info.text = "Criando Sala..." ## TODO: Fazer isso com uma animação!



func on_snapshot_data(data) -> void:
	room_data = data

	if state == CONNECT:
		
		if room_data == null or room_data.state.stringValue != "open":
			join_button.disabled = false
			host_name.editable = true
			host_name.text = ""
			host_name.placeholder_text = "Inválido"
			FirestoreListener.delete_listener("rooms", GameState.room_name, self, "on_snapshot_data")
			return
		
		if room_data.state.stringValue == "open":

			for i in range(4):

				# if room_data.players.mapValue.fields.size() -1 < i:
				if not room_data.players.mapValue.fields.has(str(i)):

					var values = room_data.players.mapValue.fields.values()
					var keys = room_data.players.mapValue.fields.keys()
					
					var dic_final: Dictionary = {}
					
					values.invert()
					keys.invert()
					
					var new_data = []
					var put_the_new_dic: bool = true
					
					var new_key: int = i
					
					for y in keys.size():

						dic_final[str(keys[y])] = values[y]
		
					dic_final[str(new_key)] = {"stringValue": GameState.user_name} ## TODO: Verificar a ordem em que se coloca os dicionarios
					
					room_info.players =  {"mapValue": {"fields": dic_final}}
					room_info.state =  {"stringValue": "open"}
					
					GameState.my_number_in_room = i
					print("_____GameState.my_number_in_room: ", GameState.my_number_in_room)
					state = WAIT
					Firebase.update_document("rooms/%s" % GameState.room_name, room_info, http)
					break

	elif state == WAIT:

		for i in range(4):

			if room_data.players.mapValue.fields.has(str(i)):

				get_node("Container/Player" + str(i)).text = room_data.players.mapValue.fields[str(i)].stringValue
			else:
				get_node("Container/Player" + str(i)).text = "-"
		
		if room_data.state.stringValue == "start":
			
			GameState.room_data = room_data
			get_tree().change_scene("res://src/MainGame/MainGame.tscn")
			
		elif room_data.state.stringValue == "cancel":
			
			FirestoreListener.delete_listener("rooms", GameState.room_name, self, "on_snapshot_data")
			emit_signal("signal_cancel_button_pressed_in_JoinGame")
			## TODO: Pode usar esse código abaixo!
			# var info = load("res://src/InfoScreen/InfoScreen.tscn").instance()
			# info.init("Atenção!", "Host Encerrou a Sessão", 3, "res://src/HostAndJoin/HostAndJoin.tscn")
			# add_child(info)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	
	var response_body := JSON.parse(body.get_string_from_ascii())

	if response_code != 200:
		print("ERROR: ", response_body.result.error.message.capitalize())

	pass


func connect_signals_with(gm_ref, func_name: String = "", func_name2: String = "") -> void:

	if gm_ref.has_method(func_name) and !is_connected("signal_join_button_pressed_in_JoinGame", gm_ref, func_name):
	
		connect("signal_join_button_pressed_in_JoinGame", gm_ref, func_name)
	
	if gm_ref.has_method(func_name) and !is_connected("signal_cancel_button_pressed_in_JoinGame", gm_ref, func_name2):
		
		connect("signal_cancel_button_pressed_in_JoinGame", gm_ref, func_name2)


func _on_Join_pressed() -> void:

	# emit_signal("signal_join_button_pressed_in_JoinGame")
	if !host_name.text.empty():
		GameState.room_name = host_name.text
		FirestoreListener.set_listener("rooms", GameState.room_name, self, "on_snapshot_data")
		join_button.disabled = true
		host_name.editable = false
	else:
		host_name.placeholder_text = "Inválido"
	


func _on_Cancel_pressed() -> void:

	if state == WAIT:

		var values = room_data.players.mapValue.fields.values()
		var keys = room_data.players.mapValue.fields.keys()
	
		var dic_final: Dictionary = {}
		print("ANTES DO INVERT")
		print("keys: ", keys)
		print("values: ", values)
	
		values.invert()
		keys.invert()
		
		print("DPS DO INVERT")
		print("keys: ", keys)
		print("values: ", values)
		
		
		var new_data = []
		
		for y in keys.size():


			if keys[y] != str(GameState.my_number_in_room):
				
				dic_final[str(keys[y])] = values[y]
			## TODO: Veriicar a ordem que se coloca os dicionarios!

		room_info.players =  {"mapValue": {"fields": dic_final}}
		room_info.state =  {"stringValue": room_data.state.stringValue}
		FirestoreListener.delete_listener("rooms", GameState.room_name, self, "on_snapshot_data")
		Firebase.update_document("rooms/%s" % GameState.room_name, room_info, http)
		
	emit_signal("signal_cancel_button_pressed_in_JoinGame")


# func remove_data_of_document()
