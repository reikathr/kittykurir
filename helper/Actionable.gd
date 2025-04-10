extends Area2D

@export var dialogue_resource : DialogueResource
@export var dialogue_start: String = "start"
@onready var labelPanel = $PanelContainer
@onready var label = $PanelContainer/Label

func _ready():
	labelPanel.visible = false
	label.text = "Enter"
	
func action() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_body_entered(body):
	if body.name == "Player":
		labelPanel.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		labelPanel.visible = false
