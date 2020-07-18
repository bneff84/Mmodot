extends Node

var debug: bool = true

var classes: Dictionary = {
	# Core
	"MmodotConfig": MmodotConfig,
	# UI
	"MmodotUi": MmodotUi,
	# Networking
	"MmodotNetworking": MmodotNetworking,
}

var registry: Dictionary = {}

var singletons: Dictionary = {}

# Load all the core stuff
func _ready():
	if debug:
		print("Mmodot._ready")

func register_class(name: String, obj) -> void:
	classes[name] = obj

func deregister_class(name: String, obj) -> void:
	if classes.has(name):
		classes.erase(name)

func get_registry() -> Dictionary:
	return registry;

func get_singleton(name: String):
	# if this exists in the instances registry, get it
	if singletons.has(name):
		return singletons.get(name)
	# if not, create it
	var instance = get_instance(name)
	singletons.set(name, instance)
	return instance

func get_instance(name: String):
	if classes.has(name):
		return classes[name].new()
	print("Error: Class {name} does not exist or is not registered. Insure you have added it to the classes Dictionary in the main Mmodot class.".format({'name': name}))
	
