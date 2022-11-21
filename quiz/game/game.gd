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
onready var question_container: VBoxContainer = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer
onready var conter_questions: Label = $MarginContainer/VBoxContainer/BarContainer/Container/Counter
onready var question: Label = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Question
onready var alternative_1: Control = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative1
onready var alternative_2: Control = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative2
onready var alternative_3: Control = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative3
onready var alternative_4: Control = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative4


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_current_question()
	set_total_questions(int( API.game.get_questions().size())) 
	
	alternative_1.connect("pressed", self, "_on_Alternative1_Button_pressed")
	alternative_2.connect("pressed", self, "_on_Alternative2_Button_pressed")
	alternative_3.connect("pressed", self, "_on_Alternative3_Button_pressed")
	alternative_4.connect("pressed", self, "_on_Alternative4_Button_pressed")


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
	var counter: int = 0
	for alternative in question_container.get_children():
		if alternative is Alternative:
			counter += 1
			alternative.number.text = str(counter)
			alternative.disabled(true)
			alternative.checker_visible(false)
			alternative.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
	
	
	
	# set text
	if dictionary_questions["alternatives"].size() >= 1:
		alternative_1.message.text = " " + random_alternatives[0]
		alternative_1.disabled(false)
	else:
		alternative_1.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 2:
		alternative_2.message.text = " " + random_alternatives[1]
		alternative_2.disabled(false)
	else:
		alternative_2.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 3:
		alternative_3.message.text = " " + random_alternatives[2]
		alternative_3.disabled(false)
	else:
		alternative_3.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 4:
		alternative_4.message.text = " " + random_alternatives[3]
		alternative_4.disabled(false)
	else:
		alternative_4.set("modulate", Color(0.0, 0.0, 0.0, 0.0))


func _reveal_alternatives() -> void:
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	var correct_alternative: String = " " + dictionary_questions["alternatives"][0]["correct"]
	
	for alternative in question_container.get_children():
		if alternative is Alternative:
			if alternative.message.text == correct_alternative:
				alternative.checker_visible(true)
				alternative.set_checker_state(true)
			else:
				alternative.checker_visible(true)
				alternative.set_checker_state(false)
 

#  [SIGNAL_METHODS]
func _on_Home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_Alternative1_Button_pressed() -> void:
	alternative_1.disabled(true, true)
	alternative_2.disabled(true)
	alternative_3.disabled(true)
	alternative_4.disabled(true)
	
	print("alternative 1")
	
	_reveal_alternatives()
	
	yield(get_tree().create_timer(2), "timeout")
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()
	


func _on_Alternative2_Button_pressed() -> void:
	alternative_1.disabled(true)
	alternative_2.disabled(true, true)
	alternative_3.disabled(true)
	alternative_4.disabled(true)
	
	print("alternative 2")
	
	_reveal_alternatives()
	
	yield(get_tree().create_timer(2), "timeout")
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()


func _on_Alternative3_Button_pressed() -> void:
	alternative_1.disabled(true)
	alternative_2.disabled(true)
	alternative_3.disabled(true, true)
	alternative_4.disabled(true)
	
	print("alternative 3")
	
	_reveal_alternatives()
	
	yield(get_tree().create_timer(2), "timeout")
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()


func _on_Alternative4_Button_pressed() -> void:
	alternative_1.disabled(true)
	alternative_2.disabled(true)
	alternative_3.disabled(true)
	alternative_4.disabled(true, true)
	
	print("alternative 4")
	
	_reveal_alternatives()
	
	yield(get_tree().create_timer(2), "timeout")
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()
