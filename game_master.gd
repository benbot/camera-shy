extends Node
class_name GameMaster


@onready var vhs_anim: AnimationPlayer = $"../CameraSetup/Main/vhs/AnimationPlayer"

var current_camera: Camera = null

signal camera_changed(cam: Camera)

func _camera_change(c: Camera) -> void:
  c.set_current()
  current_camera = c
  vhs_anim.stop()
  vhs_anim.play("CHANGE")
  camera_changed.emit(c)

func _ready() -> void:
  #register all cameras
  for cam in get_tree().get_nodes_in_group("camera"):
    (cam as Camera).camera_change.connect(_camera_change)
