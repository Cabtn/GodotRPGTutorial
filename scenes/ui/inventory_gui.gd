extends Control

signal opened
signal closed

@onready var inventory: Inventory = preload("res://resources/playerInventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/ui/item_stack_gui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var isOpen:bool = false

func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()

func connectSlots():
	for slot in slots:
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]

		if !inventorySlot.item: continue

		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)

		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()
	
func onSlotClicked(slot):
	pass
