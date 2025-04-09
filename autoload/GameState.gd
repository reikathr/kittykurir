extends Node

var main_scene
var world_holder
var npc_interactions := {}
var hasMetBlueCat = false
var hasPickedUpGoldfish = false
var blueCatDone = false
var hasMetGlenda = false
var hasMetAlphaba = false
var hasReunitedGalphie = false
var hasReceivedGalphieClue = false
var hasBeenToFruitStreet = false
var next_teleport_position = Vector2.ZERO
var should_teleport = false
var isCleanBunny = false
var isCleanCat = false
var isOpening = true
var playerName = "Hachi"

signal met_blue_cat
signal picked_up_goldfish
signal has_reunited_galphie
signal clean_bunny
signal clean_cat

func register_main_scene(scene):
	main_scene = scene
	world_holder = main_scene.get_node("WorldHolder")

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
	
func set_has_been_to_fruit_street(value):
	hasBeenToFruitStreet = value
	
func set_is_clean_bunny(value):
	isCleanBunny = value
	
func set_is_clean_cat(value):
	isCleanCat = value
	
func record_npc_interaction(npc_name: String):
	npc_interactions[npc_name] = npc_interactions.get(npc_name, 0) + 1

func get_npc_interaction_count(npc_name: String) -> int:
	return npc_interactions.get(npc_name, 0)
	
func _on_teleport_to(scene_name: String, pos: Vector2):
	main_scene = get_tree().current_scene
	world_holder = main_scene.get_node("WorldHolder")
	
	for child in world_holder.get_children():
		child.queue_free()

	var new_scene = load("res://scenes/" + scene_name + ".tscn").instantiate()
	world_holder.call_deferred("add_child", new_scene)

	await get_tree().process_frame

	var player = new_scene.get_node("Player")
	player.position = pos
