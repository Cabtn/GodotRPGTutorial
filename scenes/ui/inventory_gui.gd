extends Control

signal opened
signal closed

@onready var inventory: Inventory = preload("res://resources/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var isOpen:bool = false

func _ready():
	update()

func update():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()
