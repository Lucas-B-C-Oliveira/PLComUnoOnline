extends Node
class_name CardData


var type
var color
var used



func _init(t, c, u = 0) -> void:
	type = t
	color = c
	used = u


func to_string() -> String:
	return type + "_" + str(color) + "_" + str(used)


func to_text() -> String:
	return type + "_" + str(color)
