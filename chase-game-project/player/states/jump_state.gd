class_name JumpState
extends State


func enter() -> void:
	player.velocity.y = player.get_jump_launch_velocity()
	player.consume_jump_buffer()


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_horizontal(delta)

	if Input.is_action_just_released("jump"):
		player.apply_jump_cut()

	if player.velocity.y <= 0.0:
		transition_requested.emit("FallState")
