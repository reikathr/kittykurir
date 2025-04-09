extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var atlas = preload("res://level1npcs.tres")
@onready var atlas_tex := AtlasTexture.new()

func _ready():
	if !GameState.isCleanBunny:
		var region := Rect2(Vector2(32, 48), Vector2(16, 16))
		atlas_tex.atlas = atlas
		atlas_tex.region = region
		
		sprite.texture = atlas_tex
	else:
		change_sprite()
		

func change_sprite():
	var region := Rect2(Vector2(32, 80), Vector2(16, 16))
	atlas_tex.atlas = atlas
	atlas_tex.region = region
	
	sprite.texture = atlas_tex
