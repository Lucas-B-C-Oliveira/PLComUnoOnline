extends Control
class_name GameManager


onready var register_and_login: Control = $Main/RegisterAndLogin
onready var register: Control = $Main/Register
onready var login: Control = $Main/Login
onready var user_profile: Control = $Main/UserProfile



func _ready() -> void:
	register_and_login.connect_signals_with(self, "on_register_button_pressed_in_RegisterAndLogin", "on_login_button_pressed_in_RegisterAndLogin")
	register.connect_signals_with(self, "on_register_button_pressed_in_Register")
	login.connect_signals_with(self, "on_login_button_pressed_in_Login")
	user_profile.connect_signals_with(self, "on_confirm_button_pressed_in_UserProfile")


##### REGISTER AND lOGIN SCENE -> 
func on_register_button_pressed_in_RegisterAndLogin() -> void:
	change_visibility_of_nodes("Register")
	## TODO: Make this change scene with animation

func on_login_button_pressed_in_RegisterAndLogin() -> void:
	change_visibility_of_nodes("Login")
	## TODO: Make this change scene with animation
## ______________________________

##### REGISTER SCENE -> 
func on_register_button_pressed_in_Register() -> void:
	change_visibility_of_nodes("Login")
	## TODO: Make this change scene with animation
## ____________________

##### lOGIN SCENE -> 
func on_login_button_pressed_in_Login() -> void:
	change_visibility_of_nodes("UserProfile")
	self.user_profile.start()
	## TODO: Make this change scene with animation
## _________________

##### PROFILE SCENE -> 
func on_confirm_button_pressed_in_UserProfile() -> void:
	change_visibility_of_nodes("Login")
	## TODO: Make this change scene with animation
## ___________________


func change_visibility_of_nodes(name_node: String) -> void:

	self.register_and_login.visible = false
	self.register.visible = false
	self.login.visible = false
	self.user_profile.visible = false

	if name_node == "RegisterAndLogin": self.register_and_login.visible = true
	elif name_node == "Register": self.register.visible = true
	elif name_node == "Login": self.login.visible = true
	elif name_node == "UserProfile": self.user_profile.visible = true

	


