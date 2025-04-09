extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var npc_interactions := {}
var hasMetBlueCat = false
var hasPickedUpGoldfish = false
var blueCatDone = false
var hasMetGlenda = false
var hasMetAlphaba = false
var hasReunitedGalphie = false
var hasReceivedGalphieClue = false
var next_teleport_position = Vector2.ZERO
var should_teleport = false
var isOpening = true
var playerName = "Hachi"

signal met_blue_cat
signal picked_up_goldfish
signal has_reunited_galphie
signal clean_bunny
signal clean_cat

func set_has_met_blue_cat(value):
	hasMetBlueCat = value
		
func set_has_picked_up_goldfish(value):
	hasPickedUpGoldfish = value

func set_blue_cat_done(value):
	blueCatDone = value
	
func set_has_met_alphaba(value):
	hasMetAlphaba = value

func set_has_met_glenda(value):
	hasMetGlenda = value
	
func set_has_reunited_galphie(value):
	hasReunitedGalphie = value
	
func set_has_received_galphie_clue(value):
	hasReceivedGalphieClue = value
	
func set_is_opening(value):
	isOpening = value
	
func record_npc_interaction(npc_name: String):
	npc_interactions[npc_name] = npc_interactions.get(npc_name, 0) + 1

func get_npc_interaction_count(npc_name: String) -> int:
	return npc_interactions.get(npc_name, 0)
	
func _on_teleport_to(sceneName : String, pos: Vector2):
	GameState.next_teleport_position = pos
	get_tree().call_deferred("change_scene_to_file", "res://scenes/" + sceneName + ".tscn")
