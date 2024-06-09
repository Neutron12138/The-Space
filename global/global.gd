extends Node



func _ready() -> void:
	get_tree().auto_accept_quit = false
	get_tree().root.close_requested.connect(func(): exit_game_or_not())
	
	load_translation.call_deferred("res://translations/zh_CN.json")
	get_tree().reload_current_scene.call_deferred()



func change_scene(target : Node) -> Error:
	if not is_instance_valid(target):
		push_error("The target scene node (" + str(target) + ") is invalid")
		return ERR_INVALID_PARAMETER
	
	var tree : SceneTree = get_tree()
	tree.unload_current_scene()
	tree.root.add_child(target)
	tree.current_scene = target
	
	return OK



func make_alert(text : String, title : String = "UI_ALERT") -> void:
	var dlg : AcceptDialog = Resources.AlertDialogScene.instantiate()
	dlg.title = title
	dlg.dialog_text = text
	get_window().add_child(dlg)

func make_error(text : String) -> void:
	make_alert(text, "UI_ERROR")

func make_warning(text : String) -> void:
	make_alert(text, "UI_WARNING")



func load_translation(path : String) -> Error:
	var ts := TranslationServer
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	if not is_instance_valid(file):
		make_error("Unable to open translation file: \"" + path + "\".")
		return ERR_FILE_CANT_OPEN
	
	var dict : Variant = JSON.parse_string(file.get_as_text())
	if dict == null:
		make_error("Unable to parse the file (\"" + path + "\"), please make sure it is a JSON file.")
		return ERR_PARSE_ERROR
	if not dict is Dictionary:
		make_error("Wrong JSON file (\"" + path + "\"), it must be a JSON object (Dictionary in GDScript).")
		return ERR_PARSE_ERROR
	
	if not dict.has("locale"):
		make_error("Unable to find key \"locale\" in this translation file (\"" + path + "\").")
		return ERR_PARSE_ERROR
	
	if not dict.has("messages"):
		make_error("Unable to find key \"messages\" in this translation file (\"" + path + "\").")
		return ERR_PARSE_ERROR
	
	var trans : Translation = Translation.new()
	trans.locale = dict["locale"]
	for i in dict["messages"]:
		trans.add_message(i, dict["messages"][i])
	
	ts.add_translation(trans)
	return OK



func make_confirmation(text : String, on_canceled : Callable, on_confirmed : Callable, title : String = "UI_PLEASE_CONFIRM") -> void:
	var dlg : ConfirmationDialog = Resources.ConfirmationDialogScene.instantiate()
	dlg.title = title
	dlg.dialog_text = text
	dlg.on_canceled = on_canceled
	dlg.on_confirmed = on_confirmed
	get_window().add_child(dlg)



func exit_game_or_not() -> void:
	make_confirmation("UI_EXIT_GAME_OR_NOT",
	func(): pass,
	func(): get_tree().quit())
