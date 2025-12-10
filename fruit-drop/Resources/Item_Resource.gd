class_name ItemRes extends Resource
## This resource is responsible for storing the item data
## you can set up the item texture, name, given points, drop speed and its type

@export var item_texture: Texture2D
@export var item_name : String
@export var item_points : int
@export var item_drop_speed : float
@export var item_type : item_types
@export var powerup_type : powerup_types
@export var powerup_duration : float

enum item_types {
	FRUIT,
	POWER_UP,
	HAZARD
}

enum powerup_types{
	SPEED,
	SIZE_INCREASE,
	NONE
}
