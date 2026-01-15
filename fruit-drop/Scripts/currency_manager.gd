extends Node

var current_score : int = 0
var high_score : int = 0
var money_amount : int = 10

const MAX_SCORE_ADD : int = 500
const MAX_SCORE_CAP : int = 9999999
const MONEY_CONVERSION_RATE : int = 50

signal on_score_added

func _ready() -> void:
	load_currency_data()

func add_score(score_amount : int) -> void:
	if score_amount > MAX_SCORE_ADD:
		score_amount = MAX_SCORE_ADD
		
	current_score += score_amount
	current_score = clamp(current_score, 0, MAX_SCORE_CAP)
	on_score_added.emit()
	
	if current_score < 0 or current_score - score_amount < 0:
		current_score = 0

func convert_score_to_money() -> int:
	var conversion = round(current_score / MONEY_CONVERSION_RATE)
	if conversion < 1:
		conversion = 1
	return conversion
	
func update_high_score() -> void:
	if current_score > high_score:
		high_score = current_score
	
func add_money(money_to_add : int) -> void:
	money_amount += money_to_add

func reset_score() -> void:
	current_score = 0

func load_currency_data() -> void:
	money_amount = DataFile.data["Money"]
	high_score = DataFile.data["HighScore"]
