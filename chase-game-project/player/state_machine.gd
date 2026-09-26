class_name StateMachine
extends Node

signal state_changed(state_name: String)

var current_state: State
var _states: Dictionary = {}


func _ready() -> void:
	var player: PlayerController = get_parent() as PlayerController

	for child in get_children():
		if child is State:
			var state: State = child
			state.player = player
			state.state_machine = self
			state.transition_requested.connect(_on_transition_requested)
			_states[state.name] = state

	if get_child_count() > 0:
		current_state = get_child(0)
		current_state.enter()


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func handle_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


func transition_to(state_name: String) -> void:
	if not _states.has(state_name):
		return

	var next_state: State = _states[state_name]
	if next_state == current_state:
		return

	if current_state:
		current_state.exit()

	current_state = next_state
	current_state.enter()
	state_changed.emit(state_name)


func _on_transition_requested(next_state: String) -> void:
	transition_to(next_state)
