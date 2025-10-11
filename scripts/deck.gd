class_name Deck extends Node2D


const CARD_DRAW_SPEED = 0.3

var card_dict = ["Harpie", "Golem","Goat","Knight","ThiccBoi"]
var card_db_ref
#var draw_card_this_turn = false

func _ready():
	card_db_ref = preload("res://scripts/Cards_db.gd")

func draw_card() -> Card:
	card_dict.shuffle()
	
	#if draw_card_this_turn: - ENABLE to set 1 card draw per turn
		#return
	#draw_card_this_turn = true
	var card_drawn = card_dict[0]
	card_dict.erase(card_drawn)
	#
	#if card_dict.size() == 0:
		#print("Empty Deck after this")
		#$Area2D/CollisionPolygon2D.disabled = true
		#$Sprite2D.visible = false
	var card_scene = preload("res://scenes/card.tscn")
	var new_card = card_scene.instantiate()
	new_card.get_node("NameLabel").text = str(card_drawn)
	new_card.get_node("CostLabel").text = str(card_db_ref.CARDS[card_drawn][0])
	new_card.get_node("HealthLabel").text = "HP:" + str(card_db_ref.CARDS[card_drawn][1])
	new_card.get_node("AtkLabel").text = "ATK:" + str(card_db_ref.CARDS[card_drawn][2])
	new_card.get_node("DefLabel").text = "DEF:" + str(card_db_ref.CARDS[card_drawn][3])
	return new_card
