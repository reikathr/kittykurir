extends Area2D

@export var sceneName : String
@export var teleportPosition : Vector2

signal teleport_to(sceneName: String, teleport_position: Vector2)

func _ready():
	connect("teleport_to", GameState._on_teleport_to)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == "Player":
		GameState.should_teleport = true
		emit_signal("teleport_to", sceneName, teleportPosition)
	
