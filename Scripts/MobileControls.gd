extends CanvasLayer

func _ready() -> void:
	self.hide()
	
	if DisplayServer.is_touchscreen_available():
		self.show()
