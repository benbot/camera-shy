@tool
extends StaticBody3D

@onready var anim: AnimationPlayer = $AnimationPlayer

@export var door_material: Material
@export var inner_material: Material

func _ready() -> void:
  if inner_material:
    (%mesh1 as MeshInstance3D).set_surface_override_material(0, inner_material)
  if door_material:
    (%mesh2 as MeshInstance3D).set_surface_override_material(0, door_material)
    (%mesh3 as MeshInstance3D).set_surface_override_material(0, door_material)

func open():
  anim.play("OPEN")
  await anim.animation_finished
  collision_layer = 0
  hide()

func close():
  anim.play_backwards("OPEN")
  await anim.animation_finished
  collision_layer = 1
  show()
