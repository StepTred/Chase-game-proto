class_name FallState
extends State


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_horizontal(delta)

	if player.has_buffered_jump() and player.has_coyote_time():
		transition_requested.emit("JumpState")
	elif player.is_on_floor():
		if player.input_direction.length() > 0.0:
			transition_requested.emit("RunState")
		else:
			transition_requested.emit("IdleState")
