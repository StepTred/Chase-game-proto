class_name PlayerController
extends CharacterBody3D

@export_group("Movement")
@export var move_speed: float = 6.0
@export var turn_speed: float = 10.0

@export_group("Jumping")
@export var jump_velocity: float = 6.0
@export var gravity: float = 20.0

@onready var camera_pivot: CameraController = $CameraPivot


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = camera_pivot.get_movement_direction(input_dir)

	if direction.length() > 0.0:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		face_direction(direction, delta)
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()


func face_direction(direction: Vector3, delta: float) -> void:
	var target_angle: float = atan2(direction.x, direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)
