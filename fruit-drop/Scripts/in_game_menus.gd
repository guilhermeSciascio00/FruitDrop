class_name InGameMenus extends Control

#references
@onready var warning: RichTextLabel = $PauseMenu/MarginContainer/VBoxContainer/Warning
@onready var main_menu_scene : PackedScene = load("res://Scenes/main_menu.tscn")
@onready var pause_menu: MarginContainer = $PauseMenu
@onready var game_over: MarginContainer = $GameOver
@onready var money: RichTextLabel = $GameOver/MarginContainer/Money


func _on_restart_btn_mouse_entered() -> void:
	show_hide_warning_text()

func _on_restart_btn_mouse_exited() -> void:
	show_hide_warning_text()

func _on_back_to_menu_btn_mouse_entered() -> void:
	show_hide_warning_text()

func _on_back_to_menu_btn_mouse_exited() -> void:
	show_hide_warning_text()

func show_hide_warning_text() -> void:
	warning.visible = !warning.visible

func _on_resume_btn_pressed() -> void:
	Engine.time_scale = 1
	show_hide_pause_menu()

func _on_back_to_menu_btn_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
	Engine.time_scale = 1
	CurrencyManager.reset_score()

func _on_restart_btn_pressed() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1
	CurrencyManager.reset_score()

func show_hide_pause_menu() -> void:
	pause_menu.visible = !pause_menu.visible
	
func show_hide_game_over() -> void:
	game_over.visible = !game_over.visible

func _on_game_scene_on_game_paused() -> void:
	show_hide_pause_menu()

func _on_player_on_game_over() -> void:
	show_hide_game_over()
	money.text = "Money: %s " % str(CurrencyManager.money_amount)
