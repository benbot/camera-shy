extends Node3D
class_name Camera

@onready var camera: Camera3D = $"./pivot/Camera3D"
@onready var pivot: Node3D = $"./pivot"
@onready var cast: ShapeCast3D = $"./pivot/Camera3D/StaticBody3D/ShapeCast3D"

@export var mouse_sensitivity := 0.01

signal camera_change()

func get_rel_screen_pos(object: Node3D) -> Vector2:
	var screen_pos = camera.unproject_position(object.global_position)
	var rel = screen_pos / get_viewport().get_visible_rect().size - Vector2(0.5, 0.5)
	return rel

func _physics_process(_delta: float) -> void:
	set_process_input(true)
	if not camera.current:
		return

	if Input.is_action_just_pressed("fire"):
		if cast.is_colliding():
			var body = cast.get_collider(0)
			var maybe_cam = body

			while not maybe_cam is Camera and maybe_cam != null:
				maybe_cam = maybe_cam.get_parent()

			if maybe_cam != null:
				maybe_cam.call_deferred("player_activate")

func player_activate() -> void:
	camera_change.emit(self)

func set_current() -> void:
	camera.current = true

func _unhandled_input(event):
	if not camera.current:
		return
	if event is InputEventKey:
		if event.keycode == KEY_Q:
			get_tree().quit()
		if event.keycode == KEY_M and event.pressed:
			if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var x = event.relative.x if event.relative.x else 0
		var y = event.relative.y if event.relative.x else 0
		camera.rotate_x(-y * mouse_sensitivity)
		pivot.rotate_y(-x * mouse_sensitivity)
