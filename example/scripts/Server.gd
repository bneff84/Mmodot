extends Node

var _auth_server: MmodotAuthenticationServerWebsocket = MmodotAuthenticationServerWebsocket.new()

func _ready():
	_auth_server.listen()
	add_child(_auth_server)
	pass
