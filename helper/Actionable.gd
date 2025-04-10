extends Area2D

@export var dialogue_resource : DialogueResource
@export var dialogue_start: String = "start"
@export var dialogue_name: String
@onready var labelPanel = $PanelContainer
@onready var label = $PanelContainer/Label

func _ready():
	labelPanel.visible = false
	write_label(dialogue_name)
	
func make_visible():
	labelPanel.visible = true

func write_label(dialogue_name):
	label.text = dialogue_name
	
func action() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_body_entered(body):
	if body.name == "Player":
		labelPanel.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		labelPanel.visible = false
