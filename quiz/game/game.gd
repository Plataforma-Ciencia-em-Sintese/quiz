#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _total_questions: int = 0 \
		setget set_total_questions, get_total_questions
		
var _current_question: int = 0 \
		setget set_current_question, get_current_question


#  [ONREADY_VARIABLES]
onready var conter_questions: Label = $MarginContainer/VBoxContainer/BarContainer/Container/Counter
onready var question: Label = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Question
onready var alternative_1: HBoxContainer = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative1
onready var alternative_2: HBoxContainer = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative2
onready var alternative_3: HBoxContainer = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative3
onready var alternative_4: HBoxContainer = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative4


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_current_question()
	set_total_questions(int( API.game.get_questions().size())) 


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_total_questions(new_value: int) -> void:
	_total_questions = new_value
	conter_questions.text = "Pergunta: %s/%s" % [str(get_current_question() + 1), str(new_value)]


func get_total_questions() -> int:
	return _total_questions


func set_current_question(new_value: int) -> void:
	_current_question = new_value
	conter_questions.text = "Pergunta: %s/%s" % [str(new_value + 1), str(get_total_questions())]


func get_current_question() -> int:
	return _current_question


#  [PRIVATE_METHODS]
func _load_current_question() -> void:
	set_current_question(get_current_question())
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	
	question.text = dictionary_questions["question"]
	
	var random_alternatives: Array = Array([])
	random_alternatives.append(dictionary_questions["alternatives"][0]["correct"])
	if dictionary_questions["alternatives"].size() >= 2:
		random_alternatives.append(dictionary_questions["alternatives"][1]["incorrect"])
	if dictionary_questions["alternatives"].size() >= 3:
		random_alternatives.append(dictionary_questions["alternatives"][2]["incorrect"])
	if dictionary_questions["alternatives"].size() >= 4:
		random_alternatives.append(dictionary_questions["alternatives"][3]["incorrect"])
	
	randomize()
	random_alternatives.shuffle()
	var temp = random_alternatives[0]
	random_alternatives[0] = random_alternatives[random_alternatives.size()-1]
	random_alternatives[random_alternatives.size()-1] = temp
	
	# configure visibility state
	alternative_1.get_node("Button").disabled = true
	alternative_2.get_node("Button").disabled = true
	alternative_3.get_node("Button").disabled = true
	alternative_4.get_node("Button").disabled = true
	alternative_1.get_node("TextureRect").set("modulate", Color(0.0, 0.0, 0.0, 0.0))
	alternative_2.get_node("TextureRect").set("modulate", Color(0.0, 0.0, 0.0, 0.0))
	alternative_3.get_node("TextureRect").set("modulate", Color(0.0, 0.0, 0.0, 0.0))
	alternative_4.get_node("TextureRect").set("modulate", Color(0.0, 0.0, 0.0, 0.0))
	alternative_1.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
	alternative_2.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
	alternative_3.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
	alternative_4.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
	
	if dictionary_questions["alternatives"].size() >= 1:
		alternative_1.get_node("Button").text = " " + random_alternatives[0]
		alternative_1.get_node("Button").disabled = false
	else:
		alternative_1.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 2:
		alternative_2.get_node("Button").text = " " + random_alternatives[1]
		alternative_2.get_node("Button").disabled = false
	else:
		alternative_2.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 3:
		alternative_3.get_node("Button").text = " " + random_alternatives[2]
		alternative_3.get_node("Button").disabled = false
	else:
		alternative_3.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 4:
		alternative_4.get_node("Button").text = " " + random_alternatives[3]
		alternative_4.get_node("Button").disabled = false
	else:
		alternative_4.set("modulate", Color(0.0, 0.0, 0.0, 0.0))


func _reveal_alternatives() -> void:
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	var correct_alternative: String = " " + dictionary_questions["alternatives"][0]["correct"]
	
	if alternative_1.get_node("Button").text == correct_alternative:
		alternative_1.get_node("TextureRect").set("modulate", Color(0.4, 1.0, 0.33, 1.0))
	else:
		alternative_1.get_node("TextureRect").set("modulate", Color(1.0, 0.11, 0.11, 1.0))
	
	if alternative_2.get_node("Button").text == correct_alternative:
		alternative_2.get_node("TextureRect").set("modulate", Color(0.4, 1.0, 0.33, 1.0))
	else:
		alternative_2.get_node("TextureRect").set("modulate", Color(1.0, 0.11, 0.11, 1.0))
	
	if alternative_3.get_node("Button").text == correct_alternative:
		alternative_3.get_node("TextureRect").set("modulate", Color(0.4, 1.0, 0.33, 1.0))
	else:
		alternative_3.get_node("TextureRect").set("modulate", Color(1.0, 0.11, 0.11, 1.0))
	
	if alternative_4.get_node("Button").text == correct_alternative:
		alternative_4.get_node("TextureRect").set("modulate", Color(0.4, 1.0, 0.33, 1.0))
	else:
		alternative_4.get_node("TextureRect").set("modulate", Color(1.0, 0.11, 0.11, 1.0))
 

#  [SIGNAL_METHODS]
func _on_Home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_Alternative1_Button_pressed() -> void:
	alternative_1.get_node("Button").disabled = true
	alternative_2.get_node("Button").disabled = true
	alternative_3.get_node("Button").disabled = true
	alternative_4.get_node("Button").disabled = true
	
	print("alternative 1")
	
	_reveal_alternatives()
	
	yield(get_tree().create_timer(2), "timeout")
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()
	


func _on_Alternative2_Button_pressed() -> void:
	alternative_1.get_node("Button").disabled = true
	alternative_2.get_node("Button").disabled = true
	alternative_3.get_node("Button").disabled = true
	alternative_4.get_node("Button").disabled = true
	
	print("alternative 1")
	
	_reveal_alternatives()
	
	yield(get_tree().create_timer(2), "timeout")
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()


func _on_Alternative3_Button_pressed() -> void:
	alternative_1.get_node("Button").disabled = true
	alternative_2.get_node("Button").disabled = true
	alternative_3.get_node("Button").disabled = true
	alternative_4.get_node("Button").disabled = true
	
	print("alternative 1")
	
	_reveal_alternatives()
	
	yield(get_tree().create_timer(2), "timeout")
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()


func _on_Alternative4_Button_pressed() -> void:
	alternative_1.get_node("Button").disabled = true
	alternative_2.get_node("Button").disabled = true
	alternative_3.get_node("Button").disabled = true
	alternative_4.get_node("Button").disabled = true
	
	print("alternative 1")
	
	_reveal_alternatives()
	
	yield(get_tree().create_timer(2), "timeout")
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()
