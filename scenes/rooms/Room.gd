extends Node2D

@onready var playerCamera = $Player/Camera2D
@onready var dialogue = preload("res://dialogue/postoffice.dialogue")

func _ready():
	switch_camera()
	var scene_path = get_scene_file_path()
	var scene_name = scene_path.get_file().get_basename()
	if (GameState.isOpening) and (scene_name == "PostOffice"):
		DialogueManager.show_dialogue_balloon(dialogue, "start")

func switch_camera():
	playerCamera.enabled = false

	if get_node_or_null("MySceneCamera") == null:
		var camera = Camera2D.new()
		camera.name = "MySceneCamera"
		camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
		camera.position = Vector2(0, 0)
		camera.zoom = Vector2(1, 1)
		camera.position_smoothing_enabled = false
		camera.drag_horizontal_enabled = false
		camera.drag_vertical_enabled = false
		add_child(camera)

		camera.call_deferred("make_current")
