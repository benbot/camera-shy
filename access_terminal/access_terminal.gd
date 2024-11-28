extends StaticBody3D
class_name AccessTerminal


@export var corruption_time: float = 10.0 

var hacked := false

var tween: Tween

signal activated()
signal deactivated()

var shader: ShaderMaterial

func _ready():
  shader = preload("res://access_terminal/access_terminal_mat.tres").duplicate()
  shader.set_shader_parameter("corruption_amount", 0.8)
  get_node("office_desk2/office_desk").material_override = shader
  get_node("crt_monitor2/crt_monitor").material_override = shader
  get_node("computer_keyboard_012/computer_keyboard_01").material_override = shader

var corruption := 0.0 : 
  set(val):
    if tween:
      tween.kill()
      tween = null
    var amount = clampf(val, 0.0, 1.0)
    shader.set_shader_parameter("corruption_amount", amount)
    corruption = amount

func _process(_delta: float):
  if corruption == 1.0:
    hacked = true
    activated.emit()
  elif corruption != 0.0 and hacked:
    hacked = false
    deactivated.emit()

func set_corruption(c: float, speed: float = 0.0, forced: bool = false) -> void:
  if hacked and not forced:
    return

  if tween:
    push_error("Still tweening corruption")
    return

  var amount = clampf(c, 0.0, 0.5)
  tween = create_tween()

  var time := corruption_time
  if speed > 0.0:
    time = speed

  await tween.tween_property(self, "corruption", amount, time).finished

  tween = null

func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventKey:
    if event.pressed and event.keycode == KEY_H:
      if corruption == 1.0:
        set_corruption(0.0)
      else:
        set_corruption(1.0)
