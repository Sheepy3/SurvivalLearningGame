extends PanelContainer

@onready var quantity_label = $QuantityLabel
@onready var texture_rect = $MarginContainer/TextureRect
signal slot_clicked(index: int, button: int)

func set_slot_data(slot_data:SlotData):
	var item_data = slot_data.item_data
	$MarginContainer/TextureRect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	if slot_data.quantity > 1:
		$QuantityLabel.text = "x%s" % [slot_data.quantity]
		$QuantityLabel.show()
	pass


func _on_texture_rect_gui_input(event):
	if event is InputEventMouseMotion:
		pass
	elif event is InputEventMouseButton \
		and ((event.button_index == MOUSE_BUTTON_LEFT) or (event.button_index == MOUSE_BUTTON_RIGHT)) \
		and event.is_pressed():
		slot_clicked.emit(get_index(),event.button_index)
