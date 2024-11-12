extends Node3D

@onready var vp: SubViewport = $"terminal_vfx_layer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var tex = vp.get_texture()
  var vp_mesh: MeshInstance3D = %mesh
  var shader: ShaderMaterial = vp_mesh.get_surface_override_material(0)
  shader.set_shader_parameter("SCREEN_TEXTURE", tex)
