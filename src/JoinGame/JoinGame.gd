extends Control


signal signal_join_button_pressed_in_JoinGame
signal signal_cancel_button_pressed_in_JoinGame



func connect_signals_with(gm_ref, func_name: String = "", func_name2: String = "") -> void:

	if gm_ref.has_method(func_name) and !is_connected("signal_join_button_pressed_in_JoinGame", gm_ref, func_name):
    
		connect("signal_join_button_pressed_in_JoinGame", gm_ref, func_name)
    
	if gm_ref.has_method(func_name) and !is_connected("signal_cancel_button_pressed_in_JoinGame", gm_ref, func_name2):
    
        connect("signal_cancel_button_pressed_in_JoinGame", gm_ref, func_name2)


func _on_Join_pressed() -> void:

    emit_signal("signal_join_button_pressed_in_JoinGame")


func _on_Cancel_pressed() -> void:

    emit_signal("signal_cancel_button_pressed_in_JoinGame")