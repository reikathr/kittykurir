extends Area2D

@export var dialogue_resource : DialogueResource
@export var dialogue_start: String = "start"

func show_balloon() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	pass

func _on_body_entered(body):
	if !GameState.hasBeenToFruitStreet:
		if body.name == "Player":
			show_balloon()
