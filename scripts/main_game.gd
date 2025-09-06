class_name MainGame extends Node2D

var players = {}
@export var player_hand_scene: PackedScene

@onready var player:= $PlayerHand

func _ready():
	print('main game activate!')
	add_player(1,true)
	add_player(2,false)

func add_player(peer_id: int, is_local:bool):
	var hand: PlayerHand = player_hand_scene.instantiate()
	hand.name = str(peer_id)
	# position hands differently (bottom vs top for 2p)
	if peer_id == multiplayer.get_unique_id():
			hand.position = Vector2(400, 600) # bottom
	else:
		hand.position = Vector2(400, 100) # top

	add_child(hand)
	rpc("rpc_add_player", peer_id, hand.position)

@rpc("authority", "reliable")
func rpc_add_player(peer_id: int, pos: Vector2):
	if not players.has_node(str(peer_id)):
		var hand: PlayerHand = player_hand_scene.instantiate()
		hand.name = str(peer_id)
		hand.position = pos
		player.add_child(hand)
