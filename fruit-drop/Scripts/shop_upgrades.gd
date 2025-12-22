extends Node2D

@export var menu_scene : PackedScene
@onready var player_currency: RichTextLabel = $ShopUI/PlayerCurrency

@onready var speed_level: RichTextLabel = $ShopUI/UpgradeInfoSpeed/Level
@onready var speed_price: RichTextLabel = $ShopUI/UpgradeInfoSpeed/ItemPrice

@onready var size_level: RichTextLabel = $ShopUI/UpgradeInfoSize/Level
@onready var size_price: RichTextLabel = $ShopUI/UpgradeInfoSize/ItemPrice

@onready var purchase_feedback: RichTextLabel = $ShopUI/PurchaseFeedback

@onready var speed_btn: Button = $ShopUI/UpgradesBTN/SpeedBtn
@onready var size_btn: Button = $ShopUI/UpgradesBTN/SizeBtn


func _ready() -> void:
	update_visual_money()
	update_tag_info()

func _on_speed_btn_pressed() -> void:
	purchase_feedback.text = UpgradeManager.buy_upgrade(UpgradeManager.Upgrades.SPEED)
	update_visual_money()
	update_tag_info()
	display_purchase_feedback()
	disabled_upgrade_button(UpgradeManager.Upgrades.SPEED)
	
func _on_size_btn_pressed() -> void:
	purchase_feedback.text = UpgradeManager.buy_upgrade(UpgradeManager.Upgrades.BOWLSIZE)
	update_visual_money()
	update_tag_info()
	display_purchase_feedback()
	disabled_upgrade_button(UpgradeManager.Upgrades.BOWLSIZE)

func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.main_menu_scene)

func update_visual_money() -> void:
	player_currency.text = "Money: %s" % str(CurrencyManager.money_amount).pad_zeros(7)

func update_tag_info() -> void:
	#Level Update
	speed_level.text = "%s / %s" %[str(clamp(UpgradeManager.get_upgrade_level(UpgradeManager.Upgrades.SPEED),0, UpgradeManager.MAX_LEVEL_CAP - 1)), str(UpgradeManager.MAX_LEVEL_CAP - 1)]
	
	size_level.text = "%s / %s" % [str(clamp(UpgradeManager.get_upgrade_level(UpgradeManager.Upgrades.BOWLSIZE),0, UpgradeManager.MAX_LEVEL_CAP - 1)), str(UpgradeManager.MAX_LEVEL_CAP - 1)]
	
	#Price Update
	speed_price.text = "%s" % str(UpgradeManager.get_upgrade_price(UpgradeManager.Upgrades.SPEED))

	size_price.text = "%s" % str(UpgradeManager.get_upgrade_price(UpgradeManager.Upgrades.BOWLSIZE))

func display_purchase_feedback() -> void:
	purchase_feedback.visible = true
	await get_tree().create_timer(.5).timeout
	purchase_feedback.visible = false

func disabled_upgrade_button(upgrade : UpgradeManager.Upgrades) -> void:
	if UpgradeManager.is_upgrade_maxed(upgrade):
		match(upgrade):
			UpgradeManager.Upgrades.SPEED:
				speed_btn.disabled = true
				speed_price.text = "MAX"
			UpgradeManager.Upgrades.BOWLSIZE:
				size_btn.disabled = true
				size_price.text = "MAX"
