class_name Deck extends Node2D

const CARD_DRAW_SPEED = 0.3

var player_deck = ["Card_1", "Card_2","Card_3","Card_4","Card_5"]

func draw_card():
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	
	if player_deck.size() == 0:
		$Area2D/CollisionPolygon2D.disabled = true
		$Sprite2D.visible = false
	var card_scene = preload("res://scenes/card.tscn")
	var new_card = card_scene.instantiate()
	$"../../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
