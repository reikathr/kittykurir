extends Node

var clues: Array[String] = []
var selected_values := {}

var correct_answers := {
	"Name": ["Miyu", "Hiro", "Tomy", "Kei", "Hana"],
	"Age": ["10", "11", "12", "13", "14"],
	"Wallpaper": ["Stripes", "Polkadot", "Diamonds", "Chevron", "Checkers"],
	"Parents": ["Jin", "Leo", "Ken", "Rin", "Mia"],
	"Fruit": ["Strawberry", "Apple", "Tomato", "Banana", "Watermelon"],
	"Gift": ["Blocks", "Dolls", "Console", "Science Kit", "Drawing Set"]
}

signal clue_added(clue: String)
signal empty_field(empty_fields: Array)
signal wrong_answer(incorrect_fields: Array)

func add_clue(clue: String):
	if clue not in clues:
		clues.append(clue)
		emit_signal("clue_added", clue)
		print(clue)
		
func set_selection(category: String, house_index: int, value: String):
	if not selected_values.has(category):
		selected_values[category] = {}
	selected_values[category][house_index] = value
	
func validate_answers() -> bool:
	var all_filled := true
	var all_correct := true

	var empty_fields := []
	var incorrect_fields := []

	for category in correct_answers.keys():
		if not selected_values.has(category):
			print("Missing category:", category)
			all_filled = false
			all_correct = false
			# Add all 5 fields of the missing category as empty
			for i in range(5):
				empty_fields.append({ "category": category, "index": i })
			continue

		for i in range(5):
			var correct = correct_answers[category][i]
			var selected = selected_values[category].get(i, "")

			if selected == "":
				print("Empty field:", category, "House", i + 1)
				empty_fields.append({ "category": category, "index": i })
				all_filled = false
				all_correct = false
			elif selected != correct:
				print("Incorrect:", category, "House", i + 1, "Expected:", correct, "Got:", selected)
				incorrect_fields.append({ "category": category, "index": i })
				all_correct = false

	if not all_filled:
		print("Some fields are empty.")
		emit_signal("empty_field", empty_fields)
	if not all_correct:
		print("Some answers are incorrect.")
		emit_signal("wrong_answer", incorrect_fields)
	if all_correct and all_filled:
		print("All answers correct!")

	return all_correct and all_filled
