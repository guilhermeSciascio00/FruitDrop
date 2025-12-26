extends Node2D

@onready var settings_menu: MarginContainer = $CanvasLayer/SettingsMenu

func _on_playBTN_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.game_scene)

func _on_shoppingBTN_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.shopping_scene)

func _on_optionsBTN_pressed() -> void:
	show_hide_settings_menu()

func _on_quitBTN_pressed() -> void:
	get_tree().quit()

func show_hide_settings_menu() -> void:
	settings_menu.visible = !settings_menu.visible

func _on_close_btn_pressed() -> void:
	show_hide_settings_menu()
