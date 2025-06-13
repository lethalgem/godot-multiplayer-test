class_name MutiplayerTest extends Node3D


func _on_control_host_game():
	print("hosting game")
	Lobby.create_game()


func _on_control_join_game():
	print("joining game")
	Lobby.join_game()
