extends Node



@onready
var scene_tree : SceneTree = get_tree()
var game_state : GameState = null



func _ready() -> void:
	scene_tree.auto_accept_quit = false
	scene_tree.root.close_requested.connect(func(): exit_game_or_not())
	
	load_translations.call_deferred("res://translations/")
	scene_tree.reload_current_scene.call_deferred()
	
	'''
	ResourceLoader.add_resource_format_loader(GameState.Loader.new())
	ResourceSaver.add_resource_format_saver(GameState.Saver.new())
	var a := load("E:/.files/a.sp-game") as GameState
	print(str(a is GameState) + "," + str(a))
	var e := ResourceSaver.save(a, "E:/.files/b.sp-game")
	print(error_string(e))
	'''



func change_scene(target : Node, reserve : bool = false) -> Error:
	if not is_instance_valid(target):
		push_error("The target scene node (" + str(target) + ") is invalid")
		return ERR_INVALID_PARAMETER
	
	if not reserve:
		scene_tree.unload_current_scene()
	
	scene_tree.root.add_child(target)
	scene_tree.current_scene = target
	
	return OK



func make_alert(text : String, title : String = Constants.TEXT_UI_ALERT) -> void:
	var dlg : AcceptDialog = Resources.AlertDialogScene.instantiate()
	dlg.title = title
	dlg.dialog_text = text
	get_window().add_child(dlg)

func make_error(text : String) -> void:
	make_alert(text, Constants.TEXT_UI_ERROR)
	push_error(text)

func make_warning(text : String) -> void:
	make_alert(text, Constants.TEXT_UI_WARNING)
	push_warning(text)



func load_translation(path : String) -> Error:
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
	if not dict["locale"] is String:
		make_error("The value of key \"locale\" in the translation file (\"" + path + "\") must be a String.")
		return ERR_PARSE_ERROR
	
	if not dict.has("messages"):
		make_error("Unable to find key \"messages\" in this translation file (\"" + path + "\").")
		return ERR_PARSE_ERROR
	if not dict["messages"] is Dictionary:
		make_error("The value of key \"messages\" in the translation file (\"" + path + "\") must be a JSON object (Dictionary in GDScript).")
		return ERR_PARSE_ERROR
	
	var trans : Translation = Translation.new()
	trans.locale = dict["locale"]
	for src in dict["messages"]:
		var xlated : Variant = dict["messages"][src]
		if not xlated is String:
			make_error("The value of the key \"messages\" in the translated message (src: \"" +
			str(src) + "\", xlated: \"" + str(xlated) + "\") in the translated file (\"" +
			path + "\") must be a String")
			return ERR_PARSE_ERROR
		
		trans.add_message(src, xlated)
	
	TranslationServer.add_translation(trans)
	return OK

func load_translations(path : String) -> Error:
	if not path.ends_with("/") or path.ends_with("\\"):
		path += "/"
	
	var dir : DirAccess = DirAccess.open(path)
	if not is_instance_valid(dir):
		make_error("Unable to open translation file directory: \"" + path + "\".")
		return ERR_FILE_CANT_OPEN
	
	var err : Error = OK
	dir.list_dir_begin()
	var filename : String = dir.get_next()
	while filename != "":
		if not dir.current_is_dir():
			var e : Error = load_translation(path + filename)
			if e != OK:
				err = e
		filename = dir.get_next()
	return err



func make_confirmation(text : String, on_canceled : Callable, on_confirmed : Callable, title : String = Constants.TEXT_UI_PLEASE_CONFIRM) -> void:
	var dlg : ConfirmationDialog = Resources.ConfirmationDialogScene.instantiate()
	dlg.title = title
	dlg.dialog_text = text
	dlg.on_canceled = on_canceled
	dlg.on_confirmed = on_confirmed
	get_window().add_child(dlg)



func exit_game_or_not() -> void:
	make_confirmation(Constants.TEXT_UI_EXIT_GAME_OR_NOT,
	func(): pass,
	func(): scene_tree.quit())



func backend_load_scene() -> Error:
	push_error("unfinished function")
	return OK
