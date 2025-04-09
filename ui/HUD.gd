extends CanvasLayer

@onready var notebook_container = $NotebookContainer
@onready var show_button = $ShowNotebookButton

const OVERLAY_SCENE_PATH := "res://ui/Notebook.tscn"

var overlay_instance: Control

func _ready():
	pass

func _on_show_button_pressed():
	print('pressed')
	if overlay_instance == null:
		overlay_instance = load(OVERLAY_SCENE_PATH).instantiate()
		overlay_instance.name = "OverlayUI"
		overlay_instance.visible = true
		notebook_container.add_child(overlay_instance)
	else:
		overlay_instance.visible = not overlay_instance.visible
