class_name PlayerController
extends CharacterBody3D

@export_group("Movement")
@export var max_speed: float = 8.0
@export var acceleration: float = 40.0
@export var deceleration: float = 50.0
@export var air_control_multiplier: float = 0.35
@export var turn_speed: float = 12.0

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
	var target_velocity: Vector3 = direction * max_speed
	var rate: float = acceleration if direction.length() > 0.0 else deceleration
	if not is_on_floor():
		rate *= air_control_multiplier

	velocity.x = move_toward(velocity.x, target_velocity.x, rate * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, rate * delta)

	if direction.length() > 0.0:
		face_direction(direction, delta)

	move_and_slide()


func face_direction(direction: Vector3, delta: float) -> void:
	var target_angle: float = atan2(direction.x, direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)
