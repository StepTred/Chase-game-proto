class_name CameraController
extends Node3D

@export_group("Camera")
@export var mouse_sensitivity: float = 0.0025
@export var pitch_min_degrees: float = -80.0
@export var pitch_max_degrees: float = 80.0

@onready var spring_arm: SpringArm3D = $SpringArm3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var motion: InputEventMouseMotion = event
		rotation.y -= motion.relative.x * mouse_sensitivity
		spring_arm.rotation.x -= motion.relative.y * mouse_sensitivity
		spring_arm.rotation.x = clampf(spring_arm.rotation.x, deg_to_rad(pitch_min_degrees), deg_to_rad(pitch_max_degrees))
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func get_movement_direction(input_dir: Vector2) -> Vector3:
	var direction: Vector3 = global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	direction.y = 0.0
	if direction.length() > 0.0:
		return direction.normalized()
	return Vector3.ZERO
