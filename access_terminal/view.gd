extends Camera3D

func _process(_delta: float) -> void:
  var gm = get_tree().get_first_node_in_group("gamemaster")
  var camera: Camera = gm.current_camera
  if camera == null:
    return

  global_transform = camera.camera.global_transform
  global_transform.basis = camera.camera.global_transform.basis
