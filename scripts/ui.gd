class_name UI extends CanvasLayer

signal host_game
signal join_game
signal client_function_called
signal host_function_called


func _on_host_button_pressed():
	host_game.emit()


func _on_join_button_pressed():
	join_game.emit()


func _on_client_function_button_pressed() -> void:
	client_function_called.emit()


func _on_host_function_button_pressed() -> void:
	host_function_called.emit()
