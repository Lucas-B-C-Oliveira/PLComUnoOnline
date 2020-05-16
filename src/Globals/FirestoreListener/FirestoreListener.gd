extends Node


var listener_timer_ref: Resource = load("res://src/ListenerTimer/ListenerTimer.tscn")


func set_listener(collection_name: String, document_name, who_want_that_return, name_of_function_of_return: String) -> void:

	var listener_timer: ListenerTimer = listener_timer_ref.instance()
	self.add_child(listener_timer)
	listener_timer.start_timer(collection_name, document_name, who_want_that_return, name_of_function_of_return)


func delete_listener(collection_name: String, document_name, who_want_that_return, name_of_function_of_return: String) -> void:

	var path: String = collection_name + str(document_name)

	for child in get_children():

		if child.name == path:
			child.delete_timer(who_want_that_return, name_of_function_of_return)
			return
