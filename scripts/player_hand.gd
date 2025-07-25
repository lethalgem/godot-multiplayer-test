class_name PlayerHand extends Node2D

const HAND_COUNT = 5

func _ready():
	var card_scene = preload("res://scenes/card_2d.tscn")
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
	
