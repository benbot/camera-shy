extends Node


@onready var vhs_anim: AnimationPlayer = $"../Camera3D/vhs/AnimationPlayer"
func _camera_change(c: Camera) -> void:
  c.set_current()
  vhs_anim.stop()
  vhs_anim.play("CHANGE")

func _ready() -> void:
  %vhs.show()
  #register all cameras
  for cam in get_tree().get_nodes_in_group("camera"):
    (cam as Camera).camera_change.connect(_camera_change)
