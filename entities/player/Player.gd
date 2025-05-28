extends CharacterBody2D

@export var speed := 100.0
@onready var anim := $AnimatedSprite2D
@onready var actionable_finder := $ActionableFinder
@onready var disable_movement = false
@onready var hint_arrow = $HintArrow

var hint_blink_timer = null
var last_direction := Vector2.UP
var axis : int
	
func _ready():
	DialogueManager.connect("dialogue_started", self._on_dialogue_started)
	DialogueManager.connect("dialogue_ended", self._on_dialogue_ended)
	hint_arrow.visible = false
	hint_blink_timer = Timer.new()
	hint_blink_timer.wait_time = 0.5
	hint_blink_timer.one_shot = false
	hint_blink_timer.timeout.connect(_on_hint_blink_timeout)
	add_child(hint_blink_timer)
	
func _on_dialogue_started(_resource):
	disable_movement = true
	
func _on_dialogue_ended(_resource):
	disable_movement = false
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	if not disable_movement:
		input_vector = Vector2(
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
		

func _on_hint_blink_timeout():
	hint_arrow.visible = !hint_arrow.visible
	
func show_hint_arrow(direction: String):
	hint_arrow.visible = true
	hint_blink_timer.start()

	match direction:
		"Up":
			hint_arrow.rotation_degrees = 0
		"Right":
			hint_arrow.rotation_degrees = 90
		"Down":
			hint_arrow.rotation_degrees = 180
		"Left":
			hint_arrow.rotation_degrees = 270
		_:
			hint_arrow.rotation_degrees = 0

func hide_hint_arrow():
	hint_arrow.visible = false
	hint_blink_timer.stop()
