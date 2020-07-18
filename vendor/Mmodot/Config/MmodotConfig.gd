extends Node

class_name MmodotConfig

var debug: bool = false

# Holds the main, active configuration
var config: Dictionary
# Holds the original, loaded configuration which may differ from the current one
var config_original: Dictionary
# Holds the default configuration to fallback to for undefined values
var config_default: Dictionary

# Holds the file paths for the original/default config files
var config_original_filepath: String
var config_default_filepath: String

# Loads the configuration for this object.
func load_config(filepath: String, default_filepath: String = ""):
	# load defaults first
	if (default_filepath.length()):
		if debug:
			print("Loading default configuration")
		config_default_filepath = default_filepath
		config_default = _config_to_dictionary(
			_get_configfile(config_default_filepath)
		)
	if debug:
		print("Loading configuration")
	# load the actual configuration
	config_original_filepath = filepath
	config_original = _config_to_dictionary(
		_get_configfile(config_original_filepath)
	)
	# trigger a reset to populate the config var with the loaded configuration
	reset_config()

# Gets a ConfigFile instance for a given file path.
func _get_configfile(filepath: String) -> ConfigFile:
	var configfile: ConfigFile = ConfigFile.new()
	if debug:
		print("MmodotConfig._get_configfile({filepath})".format({'filepath':filepath}))
	if configfile.load(filepath) != OK:
		#config was not loaded
		print("Error loading config file {filepath}.".format({'filepath': filepath}))
	return configfile

# Converts a ConfigFile into a two-dimensional Dictionary
func _config_to_dictionary(configfile: ConfigFile) -> Dictionary:
	if debug:
		print("MmodotConfig._config_to_dictionary()")
	var dictionary = {}
	for section in configfile.get_sections():
		if debug:
			print("Section {section} loaded".format({'section':section}))
		dictionary[section] = {}
		for key in configfile.get_section_keys(section):
			dictionary[section][key] = configfile.get_value(section, key)
			if debug:
				print("Key {section}.{key} loaded with value {value}".format({
					"key": key,
					"section": section,
					"value": dictionary[section][key],
				}))
	return dictionary

# Converts a 2-dimensional Dictionary back to a ConfigFile object
func _dictionary_to_config(dictionary: Dictionary) -> ConfigFile:
	var configfile: ConfigFile = ConfigFile.new()
	for section in dictionary:
		for key in dictionary[section]:
			configfile.set_value(section, key, dictionary[section][key])
	return configfile

# Gets a config value with optional default to fallback to
func get_value(section: String, key: String, default = null):
	var output = null
	if config.has(section):
		output = config.get(section).get(key)
	if output == null:
		if config_default.has(section):
			return config_default.get(section).get(key, default)
	return default

# Sets a value in the configuration
func set_value(section: String, key: String, value) -> void:
	if not config.has(section):
		config[section] = {}
	config[section][key] = value

# Resets the current configuration to the original loaded configuration
func reset_config() -> void:
	config = config_original.duplicate(true)

# Writes this configuration to a .ini file
func write_config(filepath: String = "") -> bool:
	if filepath.length() > 0:
		config_original_filepath = filepath
	if config_original_filepath.length() == 0:
		print("Error: No file path provided to save configuration.")
		return false
	var configfile = _dictionary_to_config(config)
	if configfile.save(filepath) == OK:
		config_original = config.duplicate(true)
		return true
	return false
