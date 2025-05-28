extends Node

var time_passed := 0.0
var counting := false

func _process(delta):
	if counting:
		time_passed += delta
		
func set_counting(value):
	counting = value
	
func get_time():
	return time_passed

func get_formatted_time() -> String:
	var minutes = int(time_passed) / 60
	var seconds = int(time_passed) % 60
	return "%02d:%02d" % [minutes, seconds]
	
func get_formatted_time_detailed() -> String:
	var minutes = int(time_passed) / 60
	var seconds = int(time_passed) % 60
	var millis = int((time_passed - int(time_passed)) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, millis]

func reset():
	time_passed = 0.0
	counting = false
