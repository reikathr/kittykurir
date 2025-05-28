extends Node

var clues: Array[String] = []
var selected_values := {}
var last_clue_time := 0.0
var max_idle_time := 10.0
var npc_source_ids := range(1, 21)

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


func _process(delta):
	if TimeManager.counting:
		var current_time = TimeManager.get_time()
		if current_time - last_clue_time > max_idle_time:
			provide_hint()
			last_clue_time = current_time 
		
func add_clue(clue: String):
	if clue not in clues:
		clues.append(clue)
		emit_signal("clue_added", clue)
		print(clue)
		last_clue_time = TimeManager.get_time()
		
func set_selection(category: String, house_index: int, value: String):
	if not selected_values.has(category):
		selected_values[category] = {}
	selected_values[category][house_index] = value
	
func validate_answers() -> bool:
	GameState.submissionResult = ""
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
		emit_signal("empty_field", empty_fields)
		GameState.submissionResult += "Some fields are still empty. "
	if not all_correct:
		emit_signal("wrong_answer", incorrect_fields)
		GameState.submissionResult += "Some fields are still wrong. "
	if all_correct and all_filled:
		TimeManager.counting = false
		GameState.submissionResult = "All answers correct!"

	return all_correct and all_filled

func provide_hint():
	var hint = get_hint_direction_text()
	print("Hint: Try heading " + hint + "!")

func reset():
	clues.clear()
	selected_values.clear()
	GameState.submissionResult = ""
	
func get_direction_to_nearest_npc_marker() -> Vector2:
	var world = GameState.world_scene
	if world == null:
		print("yikes")
		return Vector2.ZERO

	var npc_map = world.get_node("ClueLocator")
	var player = world.get_node("Player")
	if npc_map == null or player == null:
		print('oops')
		return Vector2.ZERO

	var player_pos = player.global_position
	var min_dist := INF
	var nearest_world_pos = null

	for cell in npc_map.get_used_cells():
		var world_pos = npc_map.to_global(npc_map.map_to_local(cell))
		var dist = player_pos.distance_to(world_pos)
		if dist < min_dist:
			min_dist = dist
			nearest_world_pos = world_pos

	if nearest_world_pos:
		return (nearest_world_pos - player_pos).normalized()
	else:
		return Vector2.ZERO


func get_hint_direction_text() -> String:
	var direction = get_direction_to_nearest_npc_marker()

	if direction == Vector2.ZERO:
		return "No clue found."

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return "Right"
		else:
			return "Left"
	else:
		if direction.y > 0:
			return "Down"
		else:
			return "Up"
