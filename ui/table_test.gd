extends Control

@onready var grid = $ScrollContainer/VBoxContainer/GridContainer
@onready var clue_box = $ScrollContainer/VBoxContainer/ClueBox

var custom_font : Font
var custom_theme : Theme
var dropdowns = {}
var hint_button = Button.new()

var categories = {
	"Name": ["Tomy", "Hana", "Miyu", "Kei", "Hiro"],
	"Age": ["10", "11", "12", "13", "14"],
	"Wallpaper": ["Polkadot", "Checkers", "Chevron", "Stripes", "Diamonds"],
	"Parents": ["Leo", "Mia", "Jin", "Rin", "Ken"],
	"Fruit": ["Tomato", "Apple", "Banana", "Strawberry", "Watermelon"],
	"Gift": ["Dolls", "Blocks", "Drawing Set", "Console", "Science Kit"]
}

func _ready():
	ClueManager.connect("clue_added", self.show_clue)
	GameState.connect("enable_submit", self._on_enable_submit)
	ClueManager.connect("empty_field", self._on_empty_fields)
	ClueManager.connect("wrong_answer", self._on_wrong_answers)


	grid.columns = 6
	grid.custom_minimum_size = Vector2(30, 0)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	custom_font = load("res://assets/fonts/PixelOperator.ttf")
	custom_theme = _build_dropdown_theme()

	grid.add_child(Control.new())
	for i in range(5):
		var house_label = Label.new()
		house_label.text = "House " + str(i + 1)
		house_label.add_theme_font_override("font", custom_font)
		house_label.add_theme_font_size_override("font_size", 6)
		house_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(house_label)

	for category in categories.keys():
		var label = Label.new()
		label.text = category
		label.add_theme_font_override("font", custom_font)
		label.add_theme_font_size_override("font_size", 6)
		grid.add_child(label)

		dropdowns[category] = []

		for house_index in range(5):
			var dropdown = _build_dropdown(category, house_index)
			grid.add_child(dropdown)
			dropdowns[category].append(dropdown)

	_restore_previous_selections()

	for clue in ClueManager.clues:
		show_clue(clue)


func _build_dropdown(category: String, house_index: int) -> OptionButton:
	var dropdown = OptionButton.new()
	dropdown.custom_minimum_size = Vector2(48, 10)
	dropdown.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dropdown.clip_text = true

	dropdown.add_item("")
	for option in categories[category]:
		dropdown.add_item(option)

	dropdown.select(0)
	dropdown.item_selected.connect(_on_dropdown_selected.bind(category, house_index, dropdown))
	return dropdown


func _on_dropdown_selected(index: int, category: String, house_index: int, changed_dropdown: OptionButton):
	changed_dropdown.modulate = Color(1, 1, 1)

	var selected_value = changed_dropdown.get_item_text(index)
	var previous_value = ClueManager.selected_values.get(category, {}).get(house_index, "")

	ClueManager.set_selection(category, house_index, selected_value)

	if previous_value:
		for dropdown in dropdowns[category]:
			for i in range(1, dropdown.get_item_count()):
				if dropdown.get_item_text(i) == previous_value:
					dropdown.set_item_disabled(i, false)

	for dropdown in dropdowns[category]:
		if dropdown == changed_dropdown:
			continue
		for i in range(1, dropdown.get_item_count()):
			if dropdown.get_item_text(i) == selected_value:
				dropdown.set_item_disabled(i, true)


func _restore_previous_selections():
	for category in ClueManager.selected_values.keys():
		for house_index in ClueManager.selected_values[category].keys():
			var value = ClueManager.selected_values[category][house_index]
			var dropdown = dropdowns[category][house_index]
			for i in range(dropdown.get_item_count()):
				if dropdown.get_item_text(i) == value:
					dropdown.select(i)
					_on_dropdown_selected(i, category, house_index, dropdown)
					break


func show_clue(clue_text: String):
	var clue_label = Label.new()
	clue_label.text = clue_text
	clue_label.add_theme_font_override("font", custom_font)
	clue_label.add_theme_font_size_override("font_size", 8)
	clue_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	clue_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	clue_box.add_child(clue_label)


func _build_dropdown_theme() -> Theme:
	var theme := Theme.new()
	var font := custom_font

	theme.set_font("font", "OptionButton", font)
	theme.set_font("font", "PopupMenu", font)
	theme.set_font_size("font_size", "OptionButton", 8)

	var flat := StyleBoxFlat.new()
	flat.bg_color = Color("#2e2e2e")
	flat.set_border_width_all(0)
	flat.content_margin_top = 1
	flat.content_margin_bottom = 1
	flat.content_margin_left = 2
	flat.content_margin_right = 2

	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		theme.set_stylebox(state, "OptionButton", flat)
		
	theme.set_font("font", "PopupMenu", font)
	theme.set_font_size("font_size", "PopupMenu", 12)

	return theme

func _on_enable_submit():
	if GameState.check_counter > 0:
		hint_button.text = "Check (%d left)" % GameState.check_counter
		hint_button.add_theme_font_override("font", custom_font)
		hint_button.pressed.connect(self._on_hint_pressed)
		$ScrollContainer/VBoxContainer.add_child(hint_button)
	var submit_button = Button.new()
	submit_button.text = "Submit"
	submit_button.add_theme_font_override("font", custom_font)
	submit_button.pressed.connect(self._on_submit_pressed)
	$ScrollContainer/VBoxContainer.add_child(submit_button)
	
func _on_submit_pressed():
	var result = ClueManager.validate_answers()
	GameState.validation_done.emit()
	
func _on_hint_pressed():
	GameState.check_counter -= 1
	if GameState.check_counter == 0:
		hint_button.button_pressed = false
		hint_button.disabled = true
		hint_button.text = "No hints left"
	else:
		hint_button.text = "Check (%d left)" % GameState.check_counter
	var result = ClueManager.validate_answers()
	
func _on_empty_fields(empty_fields: Array):
	_highlight_fields(empty_fields, Color("#ff4c4c"))

func _on_wrong_answers(wrong_fields: Array):
	_highlight_fields(wrong_fields, Color("#ffaaaa"))

func _highlight_fields(fields: Array, color: Color):
	for entry in fields:
		var category = entry["category"]
		var index = entry["index"]
		if dropdowns.has(category):
			var dropdown = dropdowns[category][index]
			dropdown.modulate = color
