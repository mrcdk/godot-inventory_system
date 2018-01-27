extends TextureRect

signal dragging_begin(itemSlot)
signal dragging_end()

const Item = preload("res://Item.gd")
const ItemSlotScene = preload("res://ItemSlot.tscn")

var itemDatabase = []

var items = []

var _dragging = false

func _ready():
	randomize()
	# Custom cursor
	Input.set_custom_mouse_cursor(preload("res://sprites/cursor/dwarven_gauntlet_extra_4.png"), Input.CURSOR_ARROW, Vector2(4, 2))
	Input.set_custom_mouse_cursor(preload("res://sprites/cursor/dwarven_gauntlet_extra_8.png"), Input.CURSOR_POINTING_HAND, Vector2(4, 2))
	Input.set_custom_mouse_cursor(preload("res://sprites/cursor/dwarven_gauntlet_extra_6.png"), Input.CURSOR_FORBIDDEN, Vector2(4, 2))
	Input.set_custom_mouse_cursor(preload("res://sprites/cursor/dwarven_gauntlet_extra_10.png"), Input.CURSOR_CAN_DROP, Vector2(4, 2))

	_fill_database()

	for i in 10 + (randi() % 10):
		add_item(itemDatabase[randi() % itemDatabase.size()])

	for slot in $LeftEquipContainer.get_children():
		connect("dragging_begin", slot, "_on_dragging_start")
		connect("dragging_end", slot, "_on_dragging_end")

	for slot in $RightEquipContainer.get_children():
		connect("dragging_begin", slot, "_on_dragging_start")
		connect("dragging_end", slot, "_on_dragging_end")

func add_item(item, idx = -1):

	for itemSlot in $ItemsContainer.get_children():
		if not itemSlot.item:
			itemSlot.set_item(item)

			# Connect the dragging_started signal here because I'm lazy
			if not itemSlot.has_user_signal("dragging_started"):
				itemSlot.connect("dragging_started", self, "_on_itemSlot_start_dragging")

			# Remove old mouse events
			if itemSlot.has_user_signal("mouse_entered"):
				itemSlot.disconnect("mouse_entered", self, "_set_description")
			if itemSlot.has_user_signal("mouse_exited"):
				itemSlot.disconnect("mouse_exited", self, "_set_description")

			# Connect the new mouse events
			itemSlot.connect("mouse_entered", self, "_set_description", [itemSlot])
			itemSlot.connect("mouse_exited", self, "_set_description", [null])
			break

func remove_item(idx):
	pass

func _notification(what):
	match what:
		Node.NOTIFICATION_DRAG_BEGIN:
			pass
		Node.NOTIFICATION_DRAG_END:
			_dragging = false
			_set_description(null)
			emit_signal("dragging_end")

func _on_itemSlot_start_dragging(itemSlot):
	emit_signal("dragging_begin", itemSlot)
	$ItemStatsPopup.visible = false
	_dragging = true

func _set_description(itemSlot):
	if _dragging: return;

	var name = ""
	var description = ""
	if itemSlot and itemSlot.item:
		name = itemSlot.item.name
		description = itemSlot.item.description
		if not $ItemStatsPopup.visible:
			$ItemStatsPopup.visible = true
			$ItemStatsPopup.rect_global_position = itemSlot.rect_global_position + Vector2(itemSlot.rect_size.x, 0)
			$ItemStatsPopup.set_item(itemSlot)
	else:
		$ItemStatsPopup.visible = false

	$DescriptionPanel/ItemName.bbcode_text = "[b]%s[/b]" % name
	$DescriptionPanel/DescriptionText.bbcode_text = description

func _fill_database():
	var item = Item.new()
	item.name = "Normal Axe"
	item.icon = "res://sprites/icons/icon_axe1.png"
	item.type = Item.ItemType.Weapon
	item.description = "It's a normal axe..."
	itemDatabase.append(item)

	item = Item.new()
	item.name = "Common pants"
	item.icon = "res://sprites/icons/icon_cloth_pants1.png"
	item.type = Item.ItemType.Pants
	item.description = "Just some pants you found in a random chest. They look [i]fabulous[/i] on you."
	itemDatabase.append(item)

	item = Item.new()
	item.name = "Useless [color=#00ff00]green[/color] necklace"
	item.icon = "res://sprites/icons/icon_necklace2.png"
	item.type = Item.ItemType.Necklace
	item.rarity = Item.ItemRarity.Unique
	item.description = "An unique necklace that does nothing.\nIt's [color=#00ff00]green[/color]."
	itemDatabase.append(item)

	item = Item.new()
	item.name = "Leather boots"
	item.icon = "res://sprites/icons/icon_LEATHER_boots1.png"
	item.type = Item.ItemType.Shoe
	item.rarity = Item.ItemRarity.Common
	item.description = "As the name implies, a pair of leather boots... you aren't sure if it's actual leather or not..."
	itemDatabase.append(item)

	item = Item.new()
	item.name = "Fancy ring"
	item.icon = "res://sprites/icons/icon_ring1_2.png"
	item.type = Item.ItemType.Ring
	item.rarity = Item.ItemRarity.Rare
	item.description = "A fancy ring that you bought in eBaynia. [i]The color started to fade...[/i]"
	itemDatabase.append(item)

	item = Item.new()
	item.name = "Wooden bow"
	item.icon = "res://sprites/icons/icon_XBow3.png"
	item.type = Item.ItemType.Shield
	item.rarity = Item.ItemRarity.Common
	item.description = "A common wooden bow... this was supposed to be a shield but I didn't check beforehand"
	itemDatabase.append(item)
