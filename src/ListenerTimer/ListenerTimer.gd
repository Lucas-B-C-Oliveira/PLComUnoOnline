extends Node
class_name ListenerTimer


signal return_of_request(data)

var data
var timer_on: bool = true

onready var http : HTTPRequest = $HTTPRequest



func start_timer(collection_name: String, document_name, who_want_that_return, name_of_function_of_return: String) -> void:
	
	self.name = collection_name + str(document_name)

	# Firebase.get_document("users/%s" % Firebase.user_info.id, http)
	
	var path: String = collection_name + "/%s" % document_name
	
	if !is_connected("return_of_request", who_want_that_return, name_of_function_of_return):
		connect("return_of_request", who_want_that_return, name_of_function_of_return)

	while timer_on:

		Firebase.get_document(path, http)
		yield(get_tree().create_timer(1), "timeout")


func delete_timer(who_want_that_return, name_of_function_of_return: String) -> void:
	disconnect("return_of_request", who_want_that_return, name_of_function_of_return)
	timer_on = false
	self.queue_free()


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:

	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	
	if response_code != 200:
		print("result_body.result.error.message.capitalize(): ", result_body.result.error.message.capitalize())
	else: 

		if data == result_body.fields: return ## TODO: Verify this, but never enter here
		
		data = result_body.fields
		emit_signal("return_of_request", data)
	

