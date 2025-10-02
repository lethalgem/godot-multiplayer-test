class_name MainGame extends Node2D

var peer_id:int
var player_deck:Deck
var enemy_deck:Deck
var player_hand: PlayerHand
var enemy_hand: PlayerHand
var card_manager: CardManager

var card : Card

func _ready():
	player_deck = $PlayerDeck
	enemy_deck = $EnemyDeck
	player_hand =$PlayerHand
	enemy_hand =$EnemyHand
	card_manager = $CardManager
	#add_player(peer_id)
	
func select_deck(peer_id : int) -> Deck:
	if peer_id == 1:
		return player_deck
	else:
		return enemy_deck
	return null

@rpc("any_peer")
func request_card():
	var peer_id = multiplayer.get_remote_sender_id()
	var deck = select_deck(peer_id)
	
	if deck.card_dict.size() > 0:
		var card = deck.draw_card()
		#give_card(peer_id,card)
	else:
		rpc("empty_deck", peer_id,deck)

@rpc("authority",'reliable')
func empty_deck(peer_id:int,deck:Deck):
	if deck:
		var collision = deck.get_node('Area2D/CollisionPolygon2D')
		collision.disable = true
		var sprite = deck.get_node('Sprite2D')
		sprite.visible = false
	
##func add_player(peer_id: int):
	##var hand:PlayerHand
	##if multiplayer.is_server():
		##pass
	##else:
		##pass
	##hand.name = str(peer_id)
	### position hands differently (bottom vs top for 2p)
	##if peer_id == multiplayer.get_unique_id():
			##hand.position = Vector2(400, 600) # bottom
	##else:
		##hand.position = Vector2(400, 100) # top
#
	##rpc("rpc_add_player", peer_id, hand.position)
##
##@rpc("any_peer",'call_remote',"reliable")
##func rpc_add_player(peer_id: int, pos: Vector2):
	##print("added player"+str(peer_id))
	##var hand: = player
	##hand.name = str(peer_id)
	##hand.position = pos
#
#@rpc('any_peer')
#func ask_server_for_draw():
	##This will run twice... locally and on server... i think? Dad?
	#if not multiplayer.is_server():
		#return
	#var requester = multiplayer.get_remote_sender_id()
	#if enemy_deck.card_dict.size() > 0:
		#card = enemy_deck.draw_card()
		#var card_name = card.get_node("NameLabel").text
		#if enemy_deck.card_dict.size() == 0:
			#print("empty enemy deck")
			#empty_deck.rpc('enemy_deck')
	##print("Server: got card request from peer ", requester)
	##give_card.rpc_id(requester,enemy_hand,card)
#
#func _on_card_manager_draw_card():
	#var card: Card
	#if multiplayer.is_server():
		#if player_deck.card_dict.size() > 0:
			#print("host wants card")
			#card = player_deck.draw_card()
			#var card_name = card.get_node("NameLabel").text
			#print(card_name)
			#if player_deck.card_dict.size() == 0:
				#empty_deck()
			##give_card(player_hand, card_name)
	#else:
			#ask_server_for_draw.rpc()
#
#@rpc("any_peer")
#func give_card(hand: PlayerHand, card: Card):
	#card_manager.add_child(card)
	#hand.add_card_to_hand(card, 0.3)
	#print("give card", card, multiplayer.get_unique_id())
	#
#@rpc("any_peer")
#func empty_deck():
	#print("Empty Deck!!")
	#$Area2D/CollisionPolygon2D.disabled = true
	#$Sprite2D.visible = false
