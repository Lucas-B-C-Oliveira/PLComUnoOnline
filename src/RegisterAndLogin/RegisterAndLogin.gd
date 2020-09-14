extends Control


signal signal_register_button_pressed_in_RegisterAndLogin
signal signal_login_button_pressed_in_RegisterAndLogin



func connect_signals_with(gm_ref, func_name: String = "", func2_name: String = "") -> void:

	if gm_ref.has_method(func_name) and !self.is_connected("signal_register_button_pressed_in_RegisterAndLogin", gm_ref, func_name):
		connect("signal_register_button_pressed_in_RegisterAndLogin", gm_ref, func_name)

	if gm_ref.has_method(func2_name) and !self.is_connected("signal_login_button_pressed_in_RegisterAndLogin", gm_ref, func2_name):
	
		connect("signal_login_button_pressed_in_RegisterAndLogin", gm_ref, func2_name)


func _on_RegisterButton_pressed() -> void:
	emit_signal("signal_register_button_pressed_in_RegisterAndLogin")


func _on_LoginButton_pressed() -> void:
	emit_signal("signal_login_button_pressed_in_RegisterAndLogin")