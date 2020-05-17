extends Node


var type
var color
var used



func _init(t, c, u = 0) -> void:
	type = t
	color = c
	used = u


func to_string():
	return type + "_" + str(color) + "_" + str(used)


func to_text():
	return type + "_" + str(color)
