extends Node2D

@onready var settings_menu: MarginContainer = $CanvasLayer/SettingsMenu

var main_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

@onready var main_v: HSlider = $CanvasLayer/SettingsMenu/SettingsPopUp/MarginContainer/HBoxContainer/VolumeSliders/MainV
@onready var music_v: HSlider = $CanvasLayer/SettingsMenu/SettingsPopUp/MarginContainer/HBoxContainer/VolumeSliders/MusicV
@onready var sfxv: HSlider = $CanvasLayer/SettingsMenu/SettingsPopUp/MarginContainer/HBoxContainer/VolumeSliders/SFXV

func _ready() -> void:
	load_volume_data()

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
	save_volume_data()
	DataFile.save_game()

func _on_main_v_value_changed(value: float) -> void:		
	change_bus_volume(main_bus, value)
	
func _on_music_v_value_changed(value: float) -> void:
	change_bus_volume(music_bus, value)

func _on_sfxv_value_changed(value: float) -> void:
	change_bus_volume(sfx_bus, value)

func change_bus_volume(target_bus : int, volume : float):
	
	if volume <= 0:
		volume = 0
	
	AudioServer.set_bus_volume_db(target_bus, linear_to_db(volume))

func save_volume_data() -> void:
	DataFile.data["MasterVL"] = main_v.value
	DataFile.data["MusicVL"] = music_v.value
	DataFile.data["SFXVL"] = sfxv.value
	
func load_volume_data() -> void:
	
	main_v.value = DataFile.data["MasterVL"]
	music_v.value = DataFile.data["MusicVL"]
	sfxv.value = DataFile.data["SFXVL"]
	
	change_bus_volume(main_bus, main_v.value)
	change_bus_volume(music_bus, music_v.value)
	change_bus_volume(sfx_bus, sfxv.value)
