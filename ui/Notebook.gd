extends Control

@onready var close_button =  $PanelContainer/MarginContainer/Control/ScrollContainer/VBoxContainer/Button

func _ready():
	close_button.pressed.connect(func():
		GameState.notebook_closed.emit()
		queue_free()
	)
