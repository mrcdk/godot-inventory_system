extends Control

const Item = preload("res://Item.gd")

const normalBorder = preload("res://sprites/64x64 BagSlotBorder.png")
const magicBorder = preload("res://sprites/MagicBorderV11.png")
const rareBorder = preload("res://sprites/RareBorderV11.png")
const uniqueBorder = preload("res://sprites/UniqueBorderV11.png")

export (Texture) var icon setget _set_icon
export (Item.ItemRarity) var rarity setget _set_rarity
export (Item.ItemType) var itemType = Item.ItemType.Weapon

var item


func drop_data(position, data):
	set_item(data)

func can_drop_data(position, data):
	return data and data.type == itemType

func set_item(item):
	self.item = item
	self.icon = load(item.icon)
	self.rarity = item.rarity

func _set_icon(value):
	if not value: return;

	icon = value
	$Icon.texture = value

func _set_rarity(value):
	if not value: return;

	rarity = value
	match value:
		Item.ItemRarity.Magic:
			$Border.texture = magicBorder
		Item.ItemRarity.Rare:
			$Border.texture = rareBorder
		Item.ItemRarity.Unique:
			$Border.texture = uniqueBorder
		_:
			$Border.texture = normalBorder

func _on_dragging_start(itemSlot):
	if itemSlot.item and itemSlot.item.type == itemType:
		modulate = Color(2, 2, 2)
	else:
		modulate = Color(0.8, 0.8, 0.8)
	pass

func _on_dragging_end():
	modulate = Color(1, 1, 1)
	pass