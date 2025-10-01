class_name MutiplayerTest extends Node3D


func _on_control_host_game():
	Lobby.create_game()

func _on_control_join_game():
	Lobby.join_game()

func _on_control_host_function_called() -> void:
	Lobby.host_function.rpc()

func _on_control_client_function_called() -> void:
	Lobby.client_function.rpc()

func _on_control_begin_game():
	Lobby.start_game()
