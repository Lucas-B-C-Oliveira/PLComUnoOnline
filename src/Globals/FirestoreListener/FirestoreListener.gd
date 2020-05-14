extends Node


onready var http: HTTPRequest = $HTTPRequest



func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
    var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary


func set_listener(document_name) -> void:
    ## Criar um Timer
    ## 
    var timer: Timer = Timer.new()
    timer.name = document_name
    timer.start(0.5)
    pass


func delet_listener() -> void:
    pass