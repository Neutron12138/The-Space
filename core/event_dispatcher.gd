class_name EventDispatcher
extends Node



signal mouse_button_pressed
signal mouse_button_released
signal mouse_moved(relative : Vector2, velocity : Vector2)



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_moved.emit(event.relative, event.velocity)
