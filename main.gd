extends Node3D
class_name Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  load_level("1")

func unload():
  if $level.get_child(0):
    $level.get_child(0).queue_free()

func load_level(lname: String):
  $loading.show()
  unload()
  var level_path = "res://levels/%s.tscn" % lname

  var level := load(level_path)

  $level.add_child(level.instantiate())
  $loading.hide()

func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventKey:
    if event.keycode == KEY_1 and not event.pressed:
      load_level("1")
    if event.keycode == KEY_0 and not event.pressed:
      load_level("test_room")
