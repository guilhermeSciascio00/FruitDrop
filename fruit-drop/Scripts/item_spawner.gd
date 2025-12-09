extends Node2D


@export var item_to_spawn : PackedScene
@export var spawn_offset : float
var screen_size : Vector2; 

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	screen_size = get_viewport_rect().size
	spawn_item()
	spawn_timer.start()

func spawn_item() -> void:
	var spawn_pos = get_random_pos()
	var item : ItemBase = item_to_spawn.instantiate()
	item.position = spawn_pos
	add_child(item)

func get_random_pos() -> Vector2:
	var random_pos : Vector2 = Vector2(randf_range(0 + spawn_offset, screen_size.x - spawn_offset), 0)
	return random_pos

func _on_spawn_timer_timeout() -> void:
	spawn_item()

func _on_player_on_game_over() -> void:
	spawn_timer.stop()
