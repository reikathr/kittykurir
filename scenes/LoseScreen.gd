extends Panel

func _on_restart_button_pressed():
	GameState.reset()
	ClueManager.reset()
	TimeManager.reset()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
