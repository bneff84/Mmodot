extends MmodotApiAuthenticationClient

class_name MmodotAuthenticationClientWebsocket

var _socket: WebSocketClient = WebSocketClient.new()

onready var _auth_data: Dictionary = {}
onready var _auth_object: MmodotApiAuthenticationObject = MmodotApiAuthenticationObject.new()

func _ready():
	_connect_signals()

# Make the authentication request against the authentication server and create
# an MmodotApiAuthenticationObject to contain the authentication data if the
# request was successful.
func authenticate() -> bool:
	assert(false, "This is an API class and should not be used directly.")
	return false

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

# Connect the signals to handle the websocket connection/data
func _connect_signals() -> void:
	pass

func _on_data_received() -> void:
	var data = JSON.parse(_socket.get_peer(1).get_packet().get_string_from_utf8())
	if data is Dictionary:
		# got a proper JSON response and decoded it
		if data.has('token'):
			_auth_object.set_token(data['token'])
