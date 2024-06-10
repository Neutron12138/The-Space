extends VBoxContainer

func _ready() -> void:
	var file : FileAccess = FileAccess.open(Constants.LICENSE_PATH, FileAccess.READ)
	$TabContainer/TEXT_UI_LICENSE_GAME/text.text = file.get_as_text()
	$TabContainer/TEXT_UI_LICENSE_GODOT/text.text = Engine.get_license_text()

func _on_back_pressed() -> void:
	Global.change_scene.call_deferred(Resources.StartMenuScene.instantiate())
