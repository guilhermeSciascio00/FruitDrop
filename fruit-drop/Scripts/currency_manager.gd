extends Node

var current_score : int = 0
var high_score : int = 0
var money_amount : int = 10000

const MAX_SCORE_ADD : int = 500
const MAX_SCORE_CAP : int = 9999999

signal on_score_added

func add_score(score_amount : int) -> void:
	if score_amount > MAX_SCORE_ADD:
		score_amount = MAX_SCORE_ADD
		
	current_score += score_amount
	current_score = clamp(current_score, 0, MAX_SCORE_CAP)
	on_score_added.emit()
	
	if current_score < 0 or current_score - score_amount < 0:
		current_score = 0
