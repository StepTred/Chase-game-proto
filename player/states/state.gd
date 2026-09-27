class_name State
extends Node

signal transition_requested(next_state: String)

var player: PlayerController
var state_machine: StateMachine


func enter() -> void:
	pass


func exit() -> void:
	pass


func physics_update(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> void:
	pass
