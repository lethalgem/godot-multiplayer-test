class_name Hand extends Node2D

const CARD_WIDTH = 80
const HAND_Y_POSITION = 890
const DEFAULT_CARD_MOVE_SPEED = 0.1

@export var y_hand_ratio := 0.9 # 90% down the screen
var player_hand = []
var center_screen_x

func _ready() -> void:
	center_screen_x = get_viewport().size.x/2

func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_MOVE_SPEED)

func update_hand_positions(speed):
	var y_pos = get_viewport().size.y * y_hand_ratio
	print(y_hand_ratio)
	for i in range(player_hand.size()):
#		Get new card position based on index passed in the hand
		var new_position = Vector2(calculate_card_position(i), y_pos)
		var card = player_hand[i]
		card.hand_position = new_position 
		animate_card_to_position(card, new_position, speed)

func calculate_card_position(index):
	var hand_width = get_viewport().size.x * 0.9
	var max_card_space = 120
	var card_space = min(max_card_space, hand_width/max(player_hand.size(),1))
	var total_width = (player_hand.size() - 1) * card_space
	var x_offset = center_screen_x - total_width/2 +index*card_space
	return x_offset


func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", new_position, speed)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
