#tool
#class_name API #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]


#  [SIGNALS]
signal all_request_completed
signal a_request_completed
signal all_request_failed


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
var common: RequestCommon
var game: RequestGame
var theme: RequestTheme


#  [PRIVATE_VARIABLES]
var _is_common_completed: bool = false \
		setget set_is_common_completed, get_is_common_completed

var _is_game_completed: bool = false \
		setget set_is_game_completed, get_is_game_completed

var _is_theme_completed: bool = false \
		setget set_is_theme_completed, get_is_theme_completed

var _is_request_error: bool = false \
		setget set_is_request_error, get_is_request_error


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
func _init() -> void:
	common = RequestCommonOmeka.new()
	game = RequestGameOmeka.new()
	theme = RequestThemeOmeka.new()


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	connect("a_request_completed", self, "_on_a_request_completed")
	
	add_child(common)
	common.connect("all_request_common_completed", self, "_on_all_request_common_completed")
	common.connect("request_error", self, "_on_request_error")
	
	
	add_child(game)
	game.connect("all_request_game_completed", self, "_on_all_request_game_completed")
	game.connect("request_error", self, "_on_request_error")
	
	add_child(theme)
	theme.connect("all_request_theme_completed", self, "_on_all_request_theme_completed")
	theme.connect("request_error", self, "_on_request_error")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_is_common_completed(new_value: bool) -> void:
	_is_common_completed = new_value


func get_is_common_completed() -> bool:
	return _is_common_completed


func set_is_game_completed(new_value: bool) -> void:
	_is_game_completed = new_value


func get_is_game_completed() -> bool:
	return _is_game_completed


func set_is_theme_completed(new_value: bool) -> void:
	_is_theme_completed = new_value


func get_is_theme_completed() -> bool:
	return _is_theme_completed


func set_is_request_error(new_value: bool) -> void:
	_is_request_error = new_value


func get_is_request_error() -> bool:
	return _is_request_error


func is_all_request_completed() -> bool:
	if get_is_common_completed():
		if get_is_game_completed():
			if get_is_theme_completed():
				return true

	return false


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]
func _on_all_request_common_completed() -> void:
	print("_on_all_request_common_completed()")
	set_is_common_completed(true)
	emit_signal("a_request_completed")


func _on_all_request_game_completed() -> void:
	print("_on_all_request_game_completed()")
	set_is_game_completed(true)
	emit_signal("a_request_completed")


func _on_all_request_theme_completed() -> void:
	print("_on_all_request_theme_completed()")
	set_is_theme_completed(true)
	emit_signal("a_request_completed")


func _on_a_request_completed() -> void:
	if is_all_request_completed():
		
#		var node = preload()
#		var node_instance = node.instance()
#		get_tree().get_root().add_child(node_instance)
		
		emit_signal("all_request_completed")


func _on_request_error(request_failed: String) -> void:
	if not get_is_request_error():
		set_is_request_error(true)
		emit_signal("all_request_failed")

	push_error(request_failed)
