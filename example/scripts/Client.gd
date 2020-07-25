extends Node

var _auth_client: MmodotAuthenticationClientWebsocket = MmodotAuthenticationClientWebsocket.new()
var _auth_object: MmodotApiAuthenticationObject

func _ready():
	_auth_client.connect("auth_failure", self, "_on_auth_failure")
	_auth_client.connect("auth_success", self, "_on_auth_success")
	_auth_client.set_authentication_data({
		'username': 'foo',
		'password': 'bar'
	})
	_auth_client.authenticate()
	#put this in the scene so it can run properly
	add_child(_auth_client)
	pass

func _on_auth_failure(client: MmodotAuthenticationClientWebsocket) -> void:
	print("Auth failure!")

func _on_auth_success(client: MmodotAuthenticationClientWebsocket) -> void:
	print("Auth successful!")
	print(client.get_authentication_object().get_token())
	_auth_object = client.get_authentication_object()
