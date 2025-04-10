extends CanvasLayer

@onready var notebook_container = $NotebookContainer
@onready var show_button = $MarginContainer/ShowNotebookButton

const OVERLAY_SCENE_PATH := "res://ui/Notebook.tscn"
const NAME_INPUT_OVERLAY := "res://ui/NameInput.tscn"

var notebook_overlay: Control
var name_input_overlay: Control

func _ready():
	GameState.connect("notebook_open", self._on_show_notebook)
	GameState.connect("name_input_open", self._on_show_name_input)
	GameState.connect("notebook_closed", self._show_notebook_button)
	GameState.connect("name_input_closed", self._show_notebook_button)
	show_button.pressed.connect(_on_show_button_pressed)

func _on_show_button_pressed():
	show_notebook()

func show_notebook():
	if notebook_overlay == null:
		notebook_overlay = load(OVERLAY_SCENE_PATH).instantiate()
		notebook_overlay.name = "NotebookOverlay"
		notebook_overlay.visible = true
		notebook_container.add_child(notebook_overlay)
	else:
		notebook_overlay.visible = not notebook_overlay.visible
	show_button.visible = not notebook_container.visible

func _on_show_name_input():
	if name_input_overlay == null:
		name_input_overlay = load(NAME_INPUT_OVERLAY).instantiate()
		name_input_overlay.name = "NameInputOverlay"
		name_input_overlay.visible = true
		notebook_container.add_child(name_input_overlay)
	else:
		name_input_overlay.visible = not name_input_overlay.visible
	show_button.visible = not notebook_container.visible

func _on_show_notebook():
	show_notebook()

func _show_notebook_button():
	show_button.visible = true
