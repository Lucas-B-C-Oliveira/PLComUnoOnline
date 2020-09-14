extends Control


var path



func init(warning, msg, time, scene) -> void:

	$Panel/Warning.text = warning
	$Panel/Message.text = msg
	path = scene
	yield(get_tree().create_timer(time), "timeout")
	
	if path != null:
		get_tree().change_scene(path)
	else:
		queue_free()


func _on_Timer_timeout() -> void:

	if path != null:
		get_tree().change_scene(path)
	else:
		queue_free()