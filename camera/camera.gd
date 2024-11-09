extends Camera3D

@export var mouse_sensitivity = 0.01

func _process(delta):
	print(self.unproject_position(get_tree().root.get_child(0).find_child("sphere").global_position))
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_Q:
			get_tree().quit()
		if event.keycode == KEY_M and event.pressed:
			if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var x = event.relative.x
		var y = event.relative.y
		rotate_x(-y * mouse_sensitivity)
		$"..".rotate_y(-x * mouse_sensitivity)
