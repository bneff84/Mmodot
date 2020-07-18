extends Spatial

var config: MmodotConfig = Mmodot.get_singleton('MmodotConfig')
var network: MmodotNetworking = Mmodot.get_singleton('MmodotNetworking')

# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_load_configuration()
	_start_server()
	pass # Replace with function body.
	
func _connect_signals():
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	get_tree().connect('connection_failed', self, '_connection_failed')
	get_tree().connect("network_peer_connected", self, '_network_peer_connected')
	get_tree().connect("network_peer_disconnected", self, '_network_peer_disconnected')
	
func _network_peer_connected(peer_id: int):
	print('_network_peer_connected')
	
func _network_peer_disconnected(peer_id: int):
	print('_network_peer_disconnected')
	
func _load_configuration():
	config.debug = true
	config.load_config('res://config.ini', 'res://config.defaults.ini')

func _start_server():
	network.debug = true
	var port: int = config.get_value('network', 'port', 11337)
	network.create_server(port)
	get_tree().set_network_peer(network.get_network())
