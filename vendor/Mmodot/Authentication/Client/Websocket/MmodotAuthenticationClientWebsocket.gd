# TODO: Cleanup all the unused signal listeners and see what should move into the service API
extends MmodotApiAuthenticationClient

class_name MmodotAuthenticationClientWebsocket

var _client: WebSocketClient = WebSocketClient.new()

export var hostname: String = 'localhost'
export var port: int = 5222

var _auth_data: Dictionary = {}
var _auth_object: MmodotApiAuthenticationObject = MmodotApiAuthenticationObject.new()

func _init():
	_connect_signals()

# Make the authentication request against the authentication server and create
# an MmodotApiAuthenticationObject to contain the authentication data if the
# request was successful.
func authenticate() -> void:
	print("Connecting to ws://%s:%d" % [hostname, port])
	_client.connect_to_url("ws://%s:%d" % [hostname, port])
	pass

# Set the data to be used to authenticate this request against the
# authentication server. This does not need to validate the data as it is set.
func set_authentication_data(data: Dictionary) -> void:
	_auth_data = data

# Determine if the current authentication data is valid. This does not need to
# actually validate the data against the auth server, but should be used to
# determine if all the required data is present for the authentication request.
func validate_authentication_data(data: Dictionary) -> bool:
	if _auth_data.has('username') && _auth_data.has('password'):
		return true
	return false

# Should return the object created upon a successful authentication in the
# authenticate() method.
func get_authentication_object() -> MmodotApiAuthenticationObject:
	return _auth_object

func _auth_fail() -> void:
	print("_auth_fail")
	emit_signal("auth_failure", self)

func _auth_success() -> void:
	print("_auth_success")
	emit_signal("auth_success", self)

# Connect the signals to handle the websocket connection/data
func _connect_signals() -> void:
	print("Signals connected")
	_client.connect("data_received", self, "_on_data_received")
	_client.connect("connection_error", self, "_auth_fail")
	_client.connect("connection_established", self, "_on_connection_established")
	pass

func _on_connection_established(proto: String) -> void:
	print("_on_connection_established with protocol %s" % [proto])
	_client.get_peer(1).put_packet(JSON.print(_auth_data).to_utf8())

func _on_data_received() -> void:
	print("_on_data_received")
	var _result = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8())
	print(_result.result)
	_client.disconnect_from_host()
	if _result.error != OK:
		print("Failed to parse JSON response from auth server: %s" % [_result.error_string])
		_auth_fail()
	# got a proper JSON response and decoded it
	if _result.result.has('token'):
		_auth_object.set_token(_result.result['token'])
		_auth_success()

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
