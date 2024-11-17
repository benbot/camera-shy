extends Node3D
class_name LevelBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var vp_size: Vector2 = get_viewport().size
  $"SubViewport".size = vp_size

func _unhandled_input(event: InputEvent) -> void:
  $"SubViewport".push_input(event)
