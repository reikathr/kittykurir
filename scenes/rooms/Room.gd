extends Node2D

@onready var playerCamera = $Player/Camera2D

func _ready():
	switch_camera()

func switch_camera():
	playerCamera.enabled = false
	if get_node_or_null("MySceneCamera") == null:
		var camera = Camera2D.new()
		camera.name = "MySceneCamera"
		camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
		camera.position = Vector2(1, 0)
		camera.zoom = Vector2(1, 1)
		camera.make_current()
		camera.position_smoothing_enabled = false
		camera.drag_horizontal_enabled = false
		camera.drag_vertical_enabled = false
		add_child(camera)
