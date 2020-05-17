extends Control


var path



func init(warning, msg, time, scene) -> void:

	$Panel/Warning.text = warning
	$Panel/Message.text = msg
	path = scene
	$Timer.start(time)


func _on_Timer_timeout() -> void:

	if path != null:
		get_tree().change_scene(path)
	else:
		queue_free()