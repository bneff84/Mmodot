extends Spatial

export var listen_port: int = 2000

var _server: WebSocketServer = WebSocketServer.new()

func _ready():
	_connect_signals()
	_listen()
	
func _connect_signals() -> void:
	_server.connect("data_received", self, "_on_data_received")
	_server.connect("client_connected", self, "_on_client_connected")
	_server.connect("client_disconnected", self, "_on_client_disconnected")

func _listen() -> void:
	if _server.listen(listen_port) != OK:
		print("Unable to start WebSocketServer listening on port %d" % [listen_port])
		get_tree().quit()
	print("Started auth server listening on port %d" % [listen_port])
	print("###############################################")
	print("# DO NOT USE THIS IN A PRODUCTION ENVIRONMENT #")
	print("###############################################")
	print("This is not a durable authentication server and is not meant for production use. This is only meant to illustrate the concept of a login server.")

func _on_client_connected(id, proto) -> void:
	print("Client %d connected with protocol %s" % [id,proto])

func _on_client_disconnected(id, was_clean = false) -> void:
	print("Client %d disconnected" % [id])

func _on_data_received(id) -> void:
	var data = _server.get_peer(id).get_packet().get_string_from_utf8()
	print("Got data for peer %d: %s" % [id, data])
