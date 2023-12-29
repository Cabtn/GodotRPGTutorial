extends Resource

class_name Inventory
signal updated

@export var slots: Array[InventorySlot]
 
func insert(item: InventoryItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item && slot.amount < item.maxAmount)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		emptySlots[0].item = item
		emptySlots[0].amount = 1
		
	updated.emit()
