extends Node2D


@onready var world_holder = $WorldHolder

func _ready():
	GameState.register_main_scene(self)
	GameState.connect("win", self._on_win)
	GameState.connect("lose", self._on_lose)
	var world_scene = load("res://scenes/rooms/PostOffice.tscn").instantiate()
	world_holder.add_child(world_scene)

func _on_win():
	get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")
	
func _on_lose():
	get_tree().change_scene_to_file("res://scenes/LoseScreen.tscn")
