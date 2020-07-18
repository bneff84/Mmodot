extends Node

class_name MmodotUi

var debug: bool = true;

var ui_components: Dictionary = {};

func set_debug(value: bool) -> void:
	debug = value;

# Gets a UI component from the registry
# @return bool|Control The UI component or false if it doesn't exist.
func get(name: String):
	if (ui_components.has(name)):
		return ui_components[name];
	return false;

# Registers a UI component to the registry
# @return void
func register(reference: Control, name: String) -> void:
	print("Registering {name}".format({"name": name}));
	if (ui_components.has(name)) :
		print("Warning: {name} already registered, overwriting.".format({"name": name}));
		ui_components.erase(name);
	ui_components[name] = reference;
	pass

# Remove a UI Component from the registry
# @return bool
func deregister(name: String) -> bool:
	print("Deregistering {name}".format({"name": name}));
	if (ui_components.has(name)):
		ui_components.erase(name);
		return true;
	return false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
