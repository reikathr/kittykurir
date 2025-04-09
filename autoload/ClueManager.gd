extends Node

var clues: Array[String] = []
var selected_values := {}

signal clue_added(clue: String)

func add_clue(clue: String):
	if clue not in clues:
		clues.append(clue)
		emit_signal("clue_added", clue)
		print(clue)
		
func set_selection(category: String, house_index: int, value: String):
	if not selected_values.has(category):
		selected_values[category] = {}
	selected_values[category][house_index] = value
