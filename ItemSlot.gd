extends Control

signal dragging_started(itemSlot)

const Item = preload("res://Item.gd")
const ItemSlotScene = preload("res://ItemSlot.tscn")

const normalBorder = preload("res://sprites/64x64 BagSlotBorder.png")
const magicBorder = preload("res://sprites/MagicBorderV11.png")
const rareBorder = preload("res://sprites/RareBorderV11.png")
const uniqueBorder = preload("res://sprites/UniqueBorderV11.png")

export (Texture) var icon setget _set_icon
export (Item.ItemRarity) var rarity setget _set_rarity

var item

func get_drag_data(position):
	if not item: return false;

	var preview = ItemSlotScene.instance()
	preview.modulate.a = 0.8
	preview.rect_scale = Vector2(1.2, 1.2)
	preview.get_node("Background").visible = true
	preview.set_item(item)
	set_drag_preview(preview)
	emit_signal("dragging_started", self)
	return item

func can_drop_data(position, data):
	return false

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

func _on_ItemSlot_mouse_entered():
	if not item: return;
	modulate = Color(1.5, 1.5, 1.5)


func _on_ItemSlot_mouse_exited():
	modulate = Color(1, 1, 1)
