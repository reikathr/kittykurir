extends Control

@onready var grid = $ScrollContainer/VBoxContainer/GridContainer
@onready var clue_box = $ScrollContainer/VBoxContainer/ClueBox
var custom_theme = Theme.new()
var custom_font : Font

var categories = {
	"Name": ["Miyu", "Hiro", "Tomy", "Kei", "Hana"],
	"Age": ["5", "6", "7", "8", "9"],
	"House Pattern": ["Stripes", "Polkadot", "Diamonds", "Chevron", "Checkers"],
	"Parents": ["Jin", "Leo", "Ken", "Rin", "Mia"],
	"Fruit": ["Strawberry", "Apple", "Tomato", "Banana", "Watermelon"],
	"Gift": ["Blocks", "Dolls", "Console", "Science Kit", "Drawing Set"]
}

var dropdowns = {}
var selected_values = {}

func _ready():
	ClueManager.connect("new_clue", self.show_clue)
	grid.columns = 6
	grid.custom_minimum_size = Vector2(30, 0)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	# Load font
	custom_font = load("res://assets/fonts/PixelOperator.ttf")
	custom_theme.set_font("font", "OptionButton", custom_font)
	custom_theme.set_font("font", "PopupMenu", custom_font)
	custom_theme.set_font_size("font_size", "OptionButton", 8)

	var btn_theme := Theme.new()
	btn_theme.set_font("font", "OptionButton", custom_font)
	btn_theme.set_font_size("font_size", "OptionButton", 8)
	btn_theme.set_constant("content_margin_top", "OptionButton", 0)
	btn_theme.set_constant("content_margin_bottom", "OptionButton", 0)
	btn_theme.set_constant("content_margin_left", "OptionButton", 2)
	btn_theme.set_constant("content_margin_right", "OptionButton", 2)
	btn_theme.set_constant("outline_size", "OptionButton", 0)

	var flat_box := StyleBoxFlat.new()
	flat_box.bg_color = Color("#2e2e2e")
	flat_box.set_border_width_all(0)
	flat_box.content_margin_top = 1
	flat_box.content_margin_bottom = 1
	flat_box.content_margin_left = 2
	flat_box.content_margin_right = 2
	btn_theme.set_stylebox("normal", "OptionButton", flat_box)
	btn_theme.set_stylebox("hover", "OptionButton", flat_box)
	btn_theme.set_stylebox("pressed", "OptionButton", flat_box)
	btn_theme.set_stylebox("focus", "OptionButton", flat_box)
	btn_theme.set_stylebox("disabled", "OptionButton", flat_box)
	
	custom_theme = btn_theme
	
	var popup_style := StyleBoxFlat.new()
	popup_style.bg_color = Color("#1e1e1e")
	popup_style.set_border_width_all(0)
	popup_style.content_margin_top = 2
	popup_style.content_margin_bottom = 2
	popup_style.content_margin_left = 4
	popup_style.content_margin_right = 4
	
	var popup_font := custom_font
	var popup_font_size := 12
	
	# Add column headers (House 1, House 2, ...)
	grid.add_child(Control.new())  # Placeholder for row labels
	for i in range(5):
		var house_label = Label.new()
		house_label.text = "House " + str(i + 1)
		house_label.add_theme_font_override("font", custom_font)
		house_label.add_theme_font_size_override("font_size", 6)
		house_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(house_label)

	# Initialize selected values dictionary
	for category in categories.keys():
		selected_values[category] = {}

	# Add category labels and dropdowns
	for category in categories.keys():
		var label = Label.new()
		label.text = category
		label.add_theme_font_override("font", custom_font)
		label.add_theme_font_size_override("font_size", 6)
		grid.add_child(label)

		dropdowns[category] = []

		for house_index in range(5):
			var dropdown = OptionButton.new()
			dropdown.custom_minimum_size = Vector2(50, 10)
			dropdown.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			dropdown.theme = custom_theme  
			dropdown.clip_text = true

			# Reduce padding and spacing
			dropdown.add_theme_constant_override("hseparation", 0)
			dropdown.add_theme_constant_override("margin_top", -2)
			dropdown.add_theme_constant_override("margin_bottom", -2)
			dropdown.add_theme_constant_override("outline_size", 0)
			dropdown.add_theme_constant_override("content_margin_top", 0)
			dropdown.add_theme_constant_override("content_margin_bottom", 0)
			dropdown.add_theme_constant_override("content_margin_left", 2)
			dropdown.add_theme_constant_override("content_margin_right", 2)
			
			# Dropdown popup settings
			var popup = dropdown.get_popup()
			popup.add_theme_stylebox_override("panel", popup_style)
			popup.add_theme_font_override("font", popup_font)
			popup.add_theme_font_size_override("font_size", popup_font_size)

			popup.add_theme_constant_override("item_separator", 0)
			popup.add_theme_constant_override("item_margin", 2)
			popup.add_theme_constant_override("margin_top", 0)
			popup.add_theme_constant_override("margin_bottom", 0)
			popup.add_theme_constant_override("outline_size", 0)
			popup.add_theme_constant_override("hseparation", 0)
			popup.add_theme_constant_override("v_separation", 0)


			# Add empty item first (default selection)
			dropdown.add_item("")
			for option in categories[category]:
				dropdown.add_item(option)

			dropdown.select(0)
			dropdown.item_selected.connect(_on_dropdown_selected.bind(category, house_index, dropdown))  
			grid.add_child(dropdown)
			dropdowns[category].append(dropdown)
	for clue in ClueManager.clues:
		show_clue(clue)

func _on_dropdown_selected(index: int, category: String, house_index: int, changed_dropdown: OptionButton):
	var previous_value = selected_values[category].get(house_index, "")  # Get previously selected value
	var selected_value = changed_dropdown.get_item_text(index)

	# Update stored selection
	selected_values[category][house_index] = selected_value

	# Re-enable previously selected value in all dropdowns
	if previous_value:
		for dropdown in dropdowns[category]:
			for i in range(1, dropdown.get_item_count()):
				if dropdown.get_item_text(i) == previous_value:
					dropdown.set_item_disabled(i, false)

	# Disable the new selected value in other dropdowns
	for dropdown in dropdowns[category]:
		if dropdown == changed_dropdown:
			continue
		for i in range(1, dropdown.get_item_count()):
			if dropdown.get_item_text(i) == selected_value:
				dropdown.set_item_disabled(i, true)

func show_clue(clue_text: String):
	var clue_label = Label.new()
	clue_label.text = clue_text
	clue_label.add_theme_font_size_override("font_size", 7)
	clue_label.add_theme_font_override("font", custom_font)
	clue_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	clue_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	clue_box.add_child(clue_label)
