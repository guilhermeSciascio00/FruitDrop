class_name GameScene extends Node2D

#References
@onready var score_text: RichTextLabel = $GameUI/CanvasLayer/ScoreText
@onready var lives: HBoxContainer = $GameUI/CanvasLayer/Lives
var lives_container : Array

#PowerUps
@onready var speed_pw: TextureRect = $GameUI/CanvasLayer/Powerups/Speed_PW
@onready var size_pw: TextureRect = $GameUI/CanvasLayer/Powerups/Size_PW

func _ready() -> void:
	CurrencyManager.on_score_added.connect(update_score)
	update_score()
	lives_container = lives.get_children() if lives.get_child_count() > 0 else []

func update_score() -> void:
	score_text.text = "Score: %s " % str(CurrencyManager.current_score).pad_zeros(7)

func _on_player_on_damage_taken(remaining_lives: int) -> void:
	update_lives(remaining_lives)

func _on_player_on_powerup_taken(pw_type: ItemRes.powerup_types, turnOff: bool) -> void:
	update_powerUP(pw_type, turnOff)

func update_lives(lives_amount : int) -> void:
	if lives_container:
		match(lives_amount):
			2:
				lives_container[2].visible = false
			1:
				lives_container[1].visible = false
			0:
				lives_container[0].visible = false

func update_powerUP(powerUPType : ItemRes.powerup_types, turnOff : bool) -> void:
	match powerUPType:
		ItemRes.powerup_types.SPEED:
			speed_pw.visible = !turnOff
		ItemRes.powerup_types.SIZE_INCREASE:
			size_pw.visible = !turnOff
