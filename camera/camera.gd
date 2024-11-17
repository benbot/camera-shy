extends Node3D
class_name Camera

@onready var camera: Camera3D = $"./Camera3D"
@onready var cast: ShapeCast3D = $ShapeCast3D

@export var mouse_sensitivity := 0.007

var current_hack_target: AccessTerminal

signal camera_change()

var raw_mouse_dir = Vector2.ZERO

@onready var target_fov := camera.fov
func _ready() -> void:
  if camera.current:
    camera_change.emit(self)

var camera_tween: Tween
var hack_held: float = 0.0
func _hover_check(delta: float) -> void:
  if not cast.is_colliding():
    _reset_colliding_state()
    return
  var body = cast.get_collider(0)
  match body:
    body when body is Camera:
      $"ui/camjumphint".show()
      if Input.is_action_just_released("fire"):
        body.call_deferred("player_activate")
    body when body is AccessTerminal:
      $"ui/hackhint".show()
      if Input.is_action_pressed("hack"):
        hack_held = clamp(0.0, 1.0, hack_held + (delta / body.corruption_time))
        body.corruption = hack_held

        if camera_tween:
          camera_tween.kill()
        camera.fov = lerp(target_fov, target_fov / 2.0, hack_held)
      else:
        if camera_tween:
          camera_tween.kill()
        camera_tween = create_tween()
        camera_tween.tween_property(camera, "fov", target_fov, 0.3)
        body.set_corruption(0.0, 0.3)
        hack_held = 0.0
      current_hack_target = body
    _:
      _reset_colliding_state()

func _physics_process(delta: float) -> void:
  if not camera.current:
    $"ui".hide()
    return

  raw_mouse_dir = Vector2.ZERO
  _hover_check(delta)


func _reset_colliding_state():
  for c in $ui.get_children():
    c.hide()
  if current_hack_target:
    current_hack_target.set_corruption(0.0, 0.3)
    hack_held = 0.0
    current_hack_target = null

func player_activate() -> void:
  camera_change.emit(self)

func set_current() -> void:
  camera.current = true
  $ui.show()

func _unhandled_input(event):
  if not camera.current:
    return
  if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
    rotation.x = clamp(rotation.x + -event.relative.y * mouse_sensitivity, -PI/2, PI/2)
    rotate_y(-event.relative.x * mouse_sensitivity)
    orthonormalize()
    return
  if event is InputEventKey:
    if event.keycode == KEY_Q:
      get_tree().quit()
      return
    # # TODO: REMOVEME
    # if event.keycode == KEY_H:
    # 	await create_tween().tween_property(camera, "fov", 45.0, 2.0).finished
    # 	return
    # # TODO: REMOVEME
    if event.keycode == KEY_M and event.pressed:
      if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
      else:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
      return
