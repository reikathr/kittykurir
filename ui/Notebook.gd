extends Control

@onready var close_button =  $PanelContainer/MarginContainer/Control/ScrollContainer/VBoxContainer/Button
@onready var table = $PanelContainer/MarginContainer/Control

func _ready():
	GameState.connect("validation_done", self._on_table_validation_done)
	close_button.pressed.connect(func():
		GameState.notebook_closed.emit()
		queue_free()
	)

func _on_table_validation_done():
	GameState.isValidationDone = true
	close_button.pressed.emit()
	queue_free()
