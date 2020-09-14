extends Control


signal signal_register_button_pressed_in_Register

onready var http: HTTPRequest = $HTTPRequest
onready var username: LineEdit = $Container/VBoxContainer2/Username/LineEdit
onready var password: LineEdit = $Container/VBoxContainer2/Password/LineEdit
onready var confirm: LineEdit = $Container/VBoxContainer2/Confirm/LineEdit
onready var notification: Label = $Container/Notification



func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
    
    var response_body := JSON.parse(body.get_string_from_ascii())

    print("response_body.result: ", response_body.result)

    if response_code != 200:
        notification.text = response_body.result.error.message.capitalize()
    else:
        notification.text = "Registration sucessful!"
        yield(get_tree().create_timer(1.0), "timeout") ## TODO: Remove This Line!
        emit_signal("signal_register_button_pressed_in_Register")


func _on_RegisterButton_pressed() -> void:
    
    if password.text != confirm.text or username.text.empty() or password.text.empty():
        notification.text = "Invalid password or username"
        return
    
    Firebase.register(username.text + "@godot.com", password.text, http)


func connect_signals_with(gm_ref, func_name: String = "") -> void:

    if gm_ref.has_method(func_name) and !self.is_connected("signal_register_button_pressed_in_Register", gm_ref, func_name):
        
        connect("signal_register_button_pressed_in_Register", gm_ref, func_name)
