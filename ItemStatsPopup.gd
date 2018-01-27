extends Panel

var item

func set_item(itemSlot):
	if itemSlot and itemSlot.item:
		$Stats.bbcode_text = itemSlot.item.get_stats()