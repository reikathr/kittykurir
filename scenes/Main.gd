extends Node2D


@onready var world_holder = $WorldHolder

func _ready():
	GameState.register_main_scene(self)
	var world_scene = load("res://scenes/rooms/PostOffice.tscn").instantiate()
	world_holder.add_child(world_scene)
