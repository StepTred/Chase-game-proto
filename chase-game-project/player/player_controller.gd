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
@onready var state_machine: StateMachine = $StateMachine

var input_direction: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	input_direction = camera_pivot.get_movement_direction(input_dir)

	state_machine.physics_update(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)


func apply_gravity(delta: float) -> void:
	velocity.y -= gravity * delta


func move_horizontal(delta: float) -> void:
	var target_velocity: Vector3 = input_direction * max_speed
	var rate: float = acceleration if input_direction.length() > 0.0 else deceleration
	if not is_on_floor():
		rate *= air_control_multiplier

	velocity.x = move_toward(velocity.x, target_velocity.x, rate * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, rate * delta)

	if input_direction.length() > 0.0:
		face_direction(delta)


func face_direction(delta: float) -> void:
	var target_angle: float = atan2(input_direction.x, input_direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)
