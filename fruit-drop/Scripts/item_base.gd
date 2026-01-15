class_name ItemBase extends RigidBody2D

@export var set_list : Array[Resource]
#Item attributes
var item_name : String
var item_points : int
var item_drop_speed : float
var item_type : ItemRes.item_types
var power_up_type : ItemRes.powerup_types
var power_up_duration : float
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	#Item_SetUp
	spawn_item_from_list(get_set_list())
	linear_velocity.y = item_drop_speed
	poison_the_fruit()
	

func get_set_list() -> Resource:
	var set_list_to_use : Resource
	if len(set_list) > 1:
		set_list_to_use = set_list.pick_random()
	elif len(set_list) == 1:
		set_list_to_use = set_list[0]
	else:
		printerr("There is no set o be used, please make sure to give a proper set list so the spawn can work properly")
		return
		
	return set_list_to_use

func spawn_item_from_list(list : Resource) -> void:
	
	var set_resource : ItemsSet = list
	var res_items_set : Array[Resource] = set_resource.itemslist
	var random_item : ItemRes = res_items_set.pick_random()
	
	#Item_Setup
	item_name = random_item.item_name
	item_points = random_item.item_points
	item_drop_speed = random_item.item_drop_speed
	sprite_2d.texture = random_item.item_texture
	item_type = random_item.item_type
	if item_type == ItemRes.item_types.POWER_UP:
		power_up_type = random_item.powerup_type
		power_up_duration = random_item.powerup_duration

func poison_the_fruit() -> void:
	if item_type == ItemRes.item_types.HAZARD:
		sprite_2d.self_modulate = Color.DARK_GREEN
