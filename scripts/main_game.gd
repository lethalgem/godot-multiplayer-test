class_name MainGame extends Node2D

var player_deck:Deck
var enemy_deck:Deck
var player_hand: PlayerHand
var enemy_hand: PlayerHand
var card_manager: CardManager
var peer_id

func _ready():
	peer_id = multiplayer.get_remote_sender_id()
	player_deck = $PlayerDeck
	enemy_deck = $EnemyDeck
	player_hand =$PlayerHand
	enemy_hand =$EnemyHand
	card_manager = $CardManager
	#add_player(peer_id

@rpc("any_peer","call_local")
func empty_deck(deck: String):
	if not deck:
		return
	var empty_deck = get_node_or_null(deck)
	var collision = empty_deck.get_node('Area2D/CollisionPolygon2D')
	collision.disabled = true
	var sprite = empty_deck.get_node('Sprite2D')
	sprite.visible = false

@rpc("authority")
func give_card(hand:PlayerHand, card:Card):
	if not multiplayer.is_server():
		return
	card_manager.add_child(card)
	hand.add_card_to_hand(card, 0.3)
	print("give card", card, peer_id)

@rpc("any_peer")
func request_card():
	if not multiplayer.is_server():
		return
	if enemy_deck.card_dict.size() > 0:
		var card = enemy_deck.draw_card()
		give_card.rpc_id(peer_id,enemy_hand, card)
		if enemy_deck.card_dict.size() == 0:
			var deck = enemy_deck.name
			print("empty rpc activate!") #Works
			empty_deck.rpc_id(peer_id,deck)

func _on_card_manager_draw_card():
	var card: Card
	if multiplayer.is_server():
		if player_deck.card_dict.size() > 0:
			print("host wants card")
			card = player_deck.draw_card()
			var card_name = card.get_node("NameLabel").text
			print(card_name)
			if player_deck.card_dict.size() == 0:
				var deck = player_deck.name
				print("empty rpc activate!") #Works
				rpc("empty_deck",deck) #to everyone
				#empty_deck(player_deck) #local
			give_card.rpc_id(peer_id,player_hand, card_name)
	else:
			request_card.rpc()
	

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
	###hand.position = pos
##
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

#@rpc("any_peer")
#func empty_deck():
	#print("Empty Deck!!")
	#$Area2D/CollisionPolygon2D.disabled = true
	#$Sprite2D.visible = false
