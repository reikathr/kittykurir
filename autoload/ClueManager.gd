extends Node

var clues: Array[String] = ["this is a clue",
"here's another",
"im crazy",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me",
"debugging, dont mind me"]

signal clue_added(clue: String)

func add_clue(clue: String):
	if clue not in clues:
		clues.append(clue)
		emit_signal("clue_added", clue)
		print(clue)
