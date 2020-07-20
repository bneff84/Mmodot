################################################
# This is an API Class (Abstract/Header/etc)   #
# and should not be used directly              #
################################################
extends Node

class_name MmodotApiAuthenticationObject

var token: String setget set_token, get_token

func set_token(new_token: String) -> void:
	token = new_token

func get_token() -> String:
	return token
