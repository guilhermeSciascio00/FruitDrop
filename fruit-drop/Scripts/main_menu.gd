extends Node2D

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.game_scene)

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.shopping_scene)
