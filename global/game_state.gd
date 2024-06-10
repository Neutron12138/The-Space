class_name GameState
extends Resource



const CLASS_NAME : StringName = &"GameState"
const FILE_EXTENSION : StringName = &"sp-game"



class Loader extends ResourceFormatLoader:
	func _get_recognized_extensions() -> PackedStringArray:
		return [FILE_EXTENSION]
	
	func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant:
		var file : FileAccess = FileAccess.open(path, FileAccess.READ)
		print(file.get_as_text())
		return GameState.new()



class Saver extends ResourceFormatSaver:
	func _get_recognized_extensions(resource : Resource) -> PackedStringArray:
		if resource is GameState:
			return [FILE_EXTENSION]
		return []
	
	func _recognize(resource: Resource) -> bool:
		return resource is GameState
	
	func _save(resource: Resource, path: String, flags: int) -> Error:
		var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(str(1919810))
		return OK
