extends ConfirmationDialog

@export
var on_canceled : Callable
@export
var on_confirmed : Callable

func _on_canceled() -> void:
	if on_canceled.is_valid():
		on_canceled.call()
	queue_free()

func _on_confirmed() -> void:
	if on_confirmed.is_valid():
		on_confirmed.call()
	queue_free()
