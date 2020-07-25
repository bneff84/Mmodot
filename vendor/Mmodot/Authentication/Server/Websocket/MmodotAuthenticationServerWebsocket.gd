# TODO: Cleanup all the unused signal listeners and see what should move into the service API
# TODO: Build a Service API for this
extends Node

class_name MmodotAuthenticationServerWebsocket

export var listen_port: int = 5222

var _server: WebSocketServer = WebSocketServer.new()

func _init():
	_connect_signals()
	
func _connect_signals() -> void:
	_server.connect("data_received", self, "_on_data_received")
	_server.connect("client_connected", self, "_on_client_connected")
	_server.connect("client_disconnected", self, "_on_client_disconnected")
	_server.connect("connection_failed", self, "_on_connection_failed")
	_server.connect("connection_succeeded", self, "_on_connection_succeeded")

func _on_connection_succeeded():
	print("_on_connection_succeeded")

func _on_connection_failed():
	print("_on_connection_failed")

func listen() -> void:
	if _server.listen(listen_port) != OK:
		print("Unable to start WebSocketServer listening on port %d" % [listen_port])
		get_tree().quit()
	print("Started WebSocketServer listening on port %d" % [listen_port])
	print("###############################################")
	print("# DO NOT USE THIS IN A PRODUCTION ENVIRONMENT #")
	print("###############################################")
	print("This is not a durable authentication server and is not meant for production use.")
	print("This is only meant to illustrate the concept of a login server.")

func _on_client_connected(id, proto) -> void:
	print("Client %d connected with protocol %s" % [id, proto])

func _on_client_disconnected(id, was_clean = false) -> void:
	print("Client %d disconnected, was_clean %s" % [id, was_clean])

func _on_data_received(id: int) -> void:
	var data = _server.get_peer(id).get_packet().get_string_from_utf8()
	print("Got data for peer %d: %s" % [id, data])
	var response = JSON.print({"token": str(id)})
	print("Sending response %s to peer %d" % [response, id])
	_server.get_peer(id).put_packet(response.to_utf8())

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_server.poll()
