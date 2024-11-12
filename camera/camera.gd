extends Node3D
class_name Camera

@onready var camera: Camera3D = $"./Camera3D"
@onready var cast: ShapeCast3D = $"./Camera3D/StaticBody3D/ShapeCast3D"

@export var mouse_sensitivity := 0.007

signal camera_change()

var raw_mouse_dir = Vector2.ZERO

func _ready() -> void:
  if camera.current:
    print("CAMERA")
    camera_change.emit(self)

func _physics_process(_delta: float) -> void:
  if not camera.current:
    return

  raw_mouse_dir = Vector2.ZERO

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
  if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
    camera.rotation.x = clamp(camera.rotation.x + -event.relative.y * mouse_sensitivity, -PI/2, PI/2)
    camera.rotate_y(-event.relative.x * mouse_sensitivity)
    camera.orthonormalize()
    return
  if event is InputEventKey:
    if event.keycode == KEY_Q:
      get_tree().quit()
      return
    if event.keycode == KEY_M and event.pressed:
      if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
      else:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
