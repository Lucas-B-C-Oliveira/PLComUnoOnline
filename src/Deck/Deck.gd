extends TextureRect


var back_pre: Resource = load("res://src/Deck/BackCard.tscn")


func get_drag_data(position: Vector2):
	var back = back_pre.instance()

	set_drag_preview(back)
	back.set_name("deck")
	return back