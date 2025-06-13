class_name UI extends CanvasLayer

signal host_game
signal join_game


func _on_host_button_pressed():
	host_game.emit()


func _on_join_button_pressed():
	join_game.emit()
