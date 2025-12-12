extends Node

var current_score : int = 0
var high_score : int = 0
var money_amount : int = 0

const MAX_SCORE_CAP : int = 500

signal on_score_added

func add_score(score_amount : int) -> void:
	current_score += score_amount
	on_score_added.emit()
	if score_amount > MAX_SCORE_CAP:
		score_amount = MAX_SCORE_CAP
	
	if current_score < 0 or current_score - score_amount < 0:
		current_score = 0
