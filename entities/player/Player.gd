extends CharacterBody2D

@export var speed := 100.0
@onready var anim := $AnimatedSprite2D
@onready var actionable_finder := $ActionableFinder

var last_direction := Vector2.DOWN
var axis : int
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _physics_process(delta):
		
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	velocity = input_vector * speed
	move_and_slide()

	update_animation(input_vector)
	update_actionable_finder()

func update_animation(direction: Vector2):
	var is_moving = direction.length() > 0

	if is_moving:
		last_direction = direction
		if abs(direction.x) > abs(direction.y):
			anim.flip_h = direction.x < 0
			if anim.flip_h:
				axis = 1
			else:
				axis = -1
			anim.position.x = axis * 8
			anim.play("walk_side")
		elif direction.y < 0:
			anim.play("walk_back")
		else:
			anim.play("walk_front")
	else:
		if abs(last_direction.x) > abs(last_direction.y):
			anim.flip_h = last_direction.x < 0
			if anim.flip_h:
				axis = 1
			else:
				axis = -1
			anim.position.x = axis * 8
			anim.play("idle_side")
		elif last_direction.y < 0:
			anim.play("idle_back")
		else:
			anim.play("idle_front")
			
func update_actionable_finder():
	var direction = Vector2.ZERO

	if abs(last_direction.x) > abs(last_direction.y):
		direction = Vector2(sign(last_direction.x), 0.5)
		actionable_finder.position = direction * 10
	else:
		direction = Vector2(0, sign(last_direction.y))
		actionable_finder.position = direction * 6
