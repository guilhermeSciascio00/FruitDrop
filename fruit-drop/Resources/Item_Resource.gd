class_name ItemRes extends Resource
## This resource is responsible for storing the item data
## you can set up the item texture, name, given points, drop speed and its type

@export var item_texture: Texture2D
@export var item_name : String
@export var item_points : int
@export var item_drop_speed : float
@export var item_type : item_types

enum item_types {
	FRUIT,
	POWER_UP,
	HAZARD
}
