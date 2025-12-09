extends Area2D

@onready var player: Player = %Player

func _on_body_entered(body: Node2D) -> void:
	if body is ItemBase:
		if body.item_type == ItemRes.item_types.FRUIT:
			body.queue_free()
			player.take_damage()
		else:
			body.queue_free()
