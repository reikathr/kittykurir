extends Node2D

@onready var fishTile = $TIlemap/Fish
@onready var alphaba = $Alphaba
@onready var glenda = $Glenda
@onready var player = $Player
@onready var bunny = $IceCreamBunny
@onready var eggcat = $EggCat

func _ready():
	GameState.connect("met_blue_cat", self._on_met_blue_cat)
	GameState.connect("picked_up_goldfish", self._on_picked_up_goldfish)
	GameState.connect("has_reunited_galphie", self._on_reunited_galphie)
	GameState.connect("clean_bunny", self._on_clean_bunny)
	GameState.connect("clean_cat", self._on_clean_cat)

	fishTile.enabled = GameState.hasMetBlueCat
	if GameState.should_teleport:
		set_player_position(GameState.next_teleport_position)
		GameState.should_teleport = false  # Reset

func _on_met_blue_cat():
	fishTile.enabled = true
	
func _on_picked_up_goldfish():
	fishTile.enabled = false
	
func _on_reunited_galphie():
	glenda.position.x = alphaba.position.x+16
	glenda.position.y = alphaba.position.y
	player.position.x = glenda.position.x
	player.position.y = alphaba.position.y+16

func _on_clean_bunny():
	bunny.change_sprite()

func _on_clean_cat():
	eggcat.change_sprite()
	
func set_player_position(teleportPosition: Vector2):
	player.position = teleportPosition
