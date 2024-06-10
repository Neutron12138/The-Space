extends VBoxContainer

func _ready() -> void:
	pass

func _on_new_game_pressed() -> void:
	pass

func _on_load_game_pressed() -> void:
	pass

func _on_mods_pressed() -> void:
	pass

func _on_game_settings_pressed() -> void:
	pass

func _on_others_pressed() -> void:
	Global.change_scene.call_deferred(Resources.OthersScene.instantiate())

func _on_exit_game_pressed() -> void:
	Global.exit_game_or_not()


