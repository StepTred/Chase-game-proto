class_name PlayerController
extends CharacterBody3D

@export_group("Movement")
@export var max_speed: float = 8.0
@export var acceleration: float = 40.0
@export var deceleration: float = 50.0
@export var air_control_multiplier: float = 0.35
@export var turn_speed: float = 12.0

@export_group("Jumping")
@export var jump_height: float = 2.2
@export var base_gravity: float = 20.0
@export var rise_gravity_scale: float = 1.0
@export var fall_gravity_scale: float = 1.8
@export var jump_cut_multiplier: float = 0.5
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@onready var visual: Node3D = $Visual
@onready var camera_pivot: CameraController = $CameraPivot
@onready var state_machine: StateMachine = $StateMachine

var input_direction: Vector3 = Vector3.ZERO

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0


func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	input_direction = camera_pivot.get_movement_direction(input_dir)

	_coyote_timer = coyote_time if is_on_floor() else maxf(_coyote_timer - delta, 0.0)
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time
	else:
		_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)

	state_machine.physics_update(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)


func apply_gravity(delta: float) -> void:
	var gravity_scale: float = rise_gravity_scale if velocity.y > 0.0 else fall_gravity_scale
	velocity.y -= base_gravity * gravity_scale * delta


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
	visual.rotation.y = lerp_angle(visual.rotation.y, target_angle, turn_speed * delta)


func has_buffered_jump() -> bool:
	return _jump_buffer_timer > 0.0


func has_coyote_time() -> bool:
	return _coyote_timer > 0.0


func consume_jump_buffer() -> void:
	_jump_buffer_timer = 0.0


func get_jump_launch_velocity() -> float:
	return sqrt(2.0 * base_gravity * rise_gravity_scale * jump_height)


func apply_jump_cut() -> void:
	if velocity.y > 0.0:
		velocity.y *= jump_cut_multiplier
