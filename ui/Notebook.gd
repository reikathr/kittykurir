extends Control

@onready var close_button =  $PanelContainer/MarginContainer/Control/ScrollContainer/VBoxContainer/Button

func _ready():
	print(ClueManager.clues)
	close_button.pressed.connect(func():
		queue_free()
	)
