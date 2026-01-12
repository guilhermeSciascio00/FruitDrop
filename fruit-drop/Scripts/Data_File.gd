extends Node

const FILE_PATH = "user://"
const FILE_NAME = "GameData.Data"

var data : Dictionary
var access : FileAccess
var EncryptionKey : Encryption

func _ready() -> void:
	EncryptionKey = ResourceLoader.load("res://Resources/EncryKey.tres")
	load_game()

func new_game() -> void:
	data = {
		"MasterVL" : 1,
		"MusicVL" : 1,
		"SFXVL" : 1,
		"HighScore" : 0,
		"Money" : 10,
		"Speed_Upgrade" : 0,
		"BowlSize_Upgrade" : 0
	}

func load_game() -> void:
	if FileAccess.file_exists(FILE_PATH + FILE_NAME):
		access = FileAccess.open_encrypted_with_pass(FILE_PATH + FILE_NAME, FileAccess.READ, EncryptionKey.encryption_key)
		data = JSON.parse_string(access.get_as_text())
		access.close()
	else:
		new_game()
		save_game()
	
func save_game() -> void:
	access = FileAccess.open_encrypted_with_pass(FILE_PATH + FILE_NAME, FileAccess.WRITE, EncryptionKey.encryption_key)
	access.store_string(JSON.stringify(data))
	access.close()
