extends Node

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 9999
const DEFAULT_SERVER_IP = "108.21.225.208" # IPv4 localhost
const MAX_CONNECTIONS = 20

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"name": "Name"}

var players_loaded = 0

@onready var upnp = UPNP.new()

func _ready():
	print("multiplayer loading")
	
	# Forward ports
	var discover_result = upnp.discover()
	
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			print("test")
			
			var map_result_udp = upnp.add_port_mapping(PORT, PORT, "godot_udp", "UDP", 0)
			var map_result_tcp = upnp.add_port_mapping(PORT, PORT, "godot_udp", "UDP", 0)
			
			if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				var upnp_result = upnp.add_port_mapping(PORT, PORT, "", "UDP")
				print("added port mapping for udp")
				print(upnp_result)
			else:
				print("map worked for udp")
			
			if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				var upnp_result = upnp.add_port_mapping(PORT, PORT, "", "TCP")
				print("added port mapping for tcp")
				print(upnp_result)
			else:
				print("map worked for tcp")
	
	var external_ip = upnp.query_external_address()
	print(external_ip)
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	var rng = RandomNumberGenerator.new()
	var my_random_number = rng.randi()
	player_info["name"] = "Player" + str(my_random_number)
	print("Created player: " + str(player_info.values()))

func delete_port_mapping():
	upnp.delete_port_mapping(PORT, "UDP")
	upnp.delete_port_mapping(PORT, "TCP")

func join_game(address = ""):
	print("running join game")
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		print("error joining game: ", error)
		return error
	multiplayer.multiplayer_peer = peer
	print("joined game?")


func create_game():
	print("running create game")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		print("error hosting game: ", error)
		return error
	multiplayer.multiplayer_peer = peer
	print("hosting game?")

	players[1] = player_info
	player_connected.emit(1, player_info)
	
	print(multiplayer.is_server())


func remove_multiplayer_peer():
	print("running remove multiplayer peer")
	multiplayer.multiplayer_peer = null
	players.clear()

@rpc("any_peer", "call_local")
func host_function():
	print("I'll be run on both the host and the client")
	pass

@rpc("authority", "call_remote")
func client_function():
	print("I'll only be run on the client")
	pass

# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	print("running load game")
	get_tree().change_scene_to_file(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	print("running player_loaded")
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/Game.start_game()
			players_loaded = 0


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	print("running on player connected")
	_register_player.rpc_id(id, player_info)


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	print("running register player")
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	print("running on player disconnected")
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	print("running on connected ok")
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	print("running on connected fail")
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	print("running on server disconnected")
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
