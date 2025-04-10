extends Panel

@onready var timeElapsed = $MarginContainer/VBoxContainer/TimeElapsed


func _ready():
	timeElapsed.text = "Time elapsed: "
	timeElapsed.text += TimeManager.get_formatted_time_detailed()

func _on_restart_button_pressed():
	GameState.reset()
	ClueManager.reset()
	TimeManager.reset()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
