extends Node
class_name GameMaster


@onready var vhs_anim: AnimationPlayer = $"../CameraSetup/Main/vhs/AnimationPlayer"
@onready var camera_switch_sound: AudioStreamPlayer = $CameraSwitchSound

const CAMERA_SWITCH_SOUNDS = [
	preload("res://assets/sounds/Camera Switch FX 4.ogg")
]

var current_camera: Camera = null

signal camera_changed(cam: Camera)

func _camera_change(c: Camera) -> void:
	c.set_current()
	if current_camera != null:
		current_camera.show()
	c.hide()
	current_camera = c
	vhs_anim.stop()
	vhs_anim.play("CHANGE")
	camera_changed.emit(c)
	camera_switch_sound.stream = CAMERA_SWITCH_SOUNDS.pick_random()
	camera_switch_sound.playing = true

func _ready() -> void:
	#register all cameras
	for cam in get_tree().get_nodes_in_group("camera"):
		(cam as Camera).camera_change.connect(_camera_change)


	var term: AccessTerminal = get_tree().get_first_node_in_group("access_terminal")
	if term != null:
		term.activated.connect(func():
			await create_tween().tween_interval(0.8).finished
		# $"../Control".show()
	)
