extends MarginContainer

@onready var input = $PanelContainer/MarginContainer/VBoxContainer/LineEdit
@onready var submit_button = $PanelContainer/MarginContainer/VBoxContainer/Button

func _ready():
	input.grab_focus()

func _on_submit_button_pressed():
	GameState.playerName = input.text
	GameState.name_input_closed.emit()
	queue_free()
