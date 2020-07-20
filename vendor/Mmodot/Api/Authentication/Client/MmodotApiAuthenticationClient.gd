################################################
# This is an API Class (Abstract/Header/etc)   #
# and should not be used directly              #
################################################
extends Node

class_name MmodotApiAuthenticationClient

# Make the authentication request against the authentication server and create
# an MmodotApiAuthenticationObject to contain the authentication data if the
# request was successful.
func authenticate() -> bool:
	assert(false, "This is an API class and should not be used directly.")
	return false

# Set the data to be used to authenticate this request against the
# authentication server. This does not need to validate the data as it is set.
func set_authentication_data(data: Dictionary) -> void:
	assert(false, "This is an API class and should not be used directly.")

# Determine if the current authentication data is valid. This does not need to
# actually validate the data against the auth server, but should be used to
# determine if all the required data is present for the authentication request.
func validate_authentication_data(data: Dictionary) -> bool:
	assert(false, "This is an API class and should not be used directly.")
	return false;

# Should return the object created upon a successful authentication in the
# authenticate() method.
func get_authentication_object() -> MmodotApiAuthenticationObject:
	assert(false, "This is an API class and should not be used directly.")
	return MmodotApiAuthenticationObject.new()
