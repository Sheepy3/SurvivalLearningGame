extends PanelContainer

const Slot = preload("res://inventory/slot.tscn")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData):
	populate_item_gird(inventory_data)
	pass

func populate_item_gird(inventory_data: InventoryData):
		for child in $MarginContainer/ItemGrid.get_children():
			child.queue_free()
		for slot_data in inventory_data.slot_datas:
			var slot = Slot.instantiate()
			$MarginContainer/ItemGrid.add_child(slot)
			
			slot.slot_clicked.connect(inventory_data.on_slot_clicked)
			
			if slot_data:
				slot.set_slot_data(slot_data)
				pass
