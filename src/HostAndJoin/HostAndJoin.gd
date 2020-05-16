extends Control

signal signal_host_button_pressed_in_HostAndJoin
signal signal_join_button_pressed_in_HostAndJoin
signal signal_SignOut_button_pressed_in_HostAndJoin


func _ready() -> void:
	pass


func _on_HostButton_pressed() -> void:
	emit_signal("signal_host_button_pressed_in_HostAndJoin")


func _on_JoinButton_pressed() -> void:
	emit_signal("signal_join_button_pressed_in_HostAndJoin")


func _on_SignOut_pressed() -> void:
	emit_signal("signal_SignOut_button_pressed_in_HostAndJoin")
	Firebase.user_info = {}



func connect_signals_with(gm_ref, func_name: String = "", func_name2: String = "", func_name3: String = "") -> void:

	if gm_ref.has_method(func_name) and !is_connected("signal_host_button_pressed_in_HostAndJoin", gm_ref, func_name):
	
		connect("signal_host_button_pressed_in_HostAndJoin", gm_ref, func_name)
	
	if gm_ref.has_method(func_name) and !is_connected("signal_join_button_pressed_in_HostAndJoin", gm_ref, func_name2):

		connect("signal_join_button_pressed_in_HostAndJoin", gm_ref, func_name2)
	
	if gm_ref.has_method(func_name) and !is_connected("signal_SignOut_button_pressed_in_HostAndJoin", gm_ref, func_name3):

		connect("signal_SignOut_button_pressed_in_HostAndJoin", gm_ref, func_name3)
