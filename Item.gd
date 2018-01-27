extends Reference

enum ItemRarity {
	Common,
	Magic,
	Rare,
	Unique,
}

enum ItemType {
	Consumible,

	Weapon,
	Shield,

	Helmet,
	Armor,
	Pants,
	Shoe,
	Glove,
	Necklace,
	Ring,
}

var name = ""
var icon = ""
var type = ItemType.Consumible
var rarity = ItemRarity.Common
var description = ""

func get_stats():
	return "Stats for '%s' go here" % name

