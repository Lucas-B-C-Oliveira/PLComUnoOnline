extends Control


signal signal_play_button_pressed_in_HostGame
signal signal_cancel_button_pressed_in_HostGame



func _on_Play_pressed() -> void:
	emit_signal("signal_play_button_pressed_in_HostGame")


func _on_Cancel_pressed() -> void:
	emit_signal("signal_cancel_button_pressed_in_HostGame")


func connect_signals_with(gm_ref, func_name: String = "", func_name2: String = "") -> void:

	if gm_ref.has_method(func_name) and !is_connected("signal_play_button_pressed_in_HostGame", gm_ref, func_name):
	
		connect("signal_play_button_pressed_in_HostGame", gm_ref, func_name)
	
	if gm_ref.has_method(func_name) and !is_connected("signal_cancel_button_pressed_in_HostGame", gm_ref, func_name2):

		connect("signal_cancel_button_pressed_in_HostGame", gm_ref, func_name2)
