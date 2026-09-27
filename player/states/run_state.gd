class_name RunState
extends State


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_horizontal(delta)

	if not player.is_on_floor():
		transition_requested.emit("FallState")
	elif player.has_buffered_jump():
		transition_requested.emit("JumpState")
	elif player.input_direction.length() == 0.0:
		transition_requested.emit("IdleState")
