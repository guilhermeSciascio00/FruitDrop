extends Node

var current_score : float = 0
var high_score : float = 0
var money_amount : float = 0

const MAX_SCORE_CAP : float = 500.0

func add_score(score_amount : float) -> void:
	current_score += score_amount
	
	if score_amount > MAX_SCORE_CAP:
		score_amount = MAX_SCORE_CAP
	
	if current_score < 0:
		current_score = 0
