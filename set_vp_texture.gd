extends MeshInstance3D

@export var vp_path: NodePath
@export var hidden: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !hidden:
		show()
	var shader: ShaderMaterial = get_surface_override_material(0)
	var vp_tex = get_node(vp_path).get_texture()
	shader.set_shader_parameter("SCREEN_TEXTURE", vp_tex)
