class_name EulerAngle
extends RefCounted



var yaw : float = 0.0
var pitch : float = 0.0



func calc_vector() -> Vector3:
	var y : float = sin(pitch)
	var h : float = cos(pitch)
	var x : float = sin(yaw) * h
	var z : float = cos(yaw) * h
	return Vector3(x, y, z)



# 无法保证输入与输出结果一致
# 有待调整
# 例如
# 输入{ "yaw": 3.35364719571578, "pitch": -0.97130011437717 },(-0.118752, -0.82562, -0.551588)
# 输出{ "yaw": 0.21205455241811, "pitch": -0.97130013727279 },(0.118752, -0.82562, 0.551588)
func from_vector(vector : Vector3) -> void:
	var h = sqrt(vector.x ** 2 + vector.z ** 2)
	if h == 0:
		yaw = 0.0
		pitch = PI / 2.0 if vector.y > 0.0 else -PI / 2.0
	else:
		yaw = atan(vector.x / vector.z)
		pitch = atan(vector.y / h)



func _to_string() -> String:
	return str({
		"yaw" : yaw,
		"pitch" : pitch
	})



static func make_by_angles(yaw : float, pitch : float) -> EulerAngle:
	var result : EulerAngle = EulerAngle.new()
	result.yaw = yaw
	result.pitch = pitch
	return result

static func make_by_vector(vector : Vector3) -> EulerAngle:
	var result : EulerAngle = EulerAngle.new()
	result.from_vector(vector)
	return result

static func make_by_string(string : String) -> EulerAngle:
	var result : EulerAngle = EulerAngle.new()
	
	var dict : Variant = JSON.parse_string(string)
	if dict == null:
		push_error("Unable to parse the string (\"" + string +
		"\") as a JSON object (Dictionary in GDScript).")
		return result
	if not dict is Dictionary:
		push_error("\"" + string + "\" is not a JSON object (Dictionary in GDScript).")
		return result
	
	if not dict.has("yaw"):
		push_error("The dictionary must have the key \"yaw\".")
		return result
	if not dict.has("pitch"):
		push_error("The dictionary must have the key \"pitch\".")
		return result
	
	if not dict["yaw"] is float:
		push_error("The value of key \"yaw\" must be a float.")
		return result
	if not dict["pitch"] is float:
		push_error("The value of key \"pitch\" must be a float.")
		return result
	
	result.yaw = dict["yaw"]
	result.pitch = dict["pitch"]
	
	return result
