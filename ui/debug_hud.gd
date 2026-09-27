class_name DebugHud
extends CanvasLayer

@export var player: PlayerController:
	set(value):
		player = value
		if player and player.state_machine:
			player.state_machine.state_changed.connect(_on_state_changed)
			_on_state_changed(player.state_machine.current_state.name)

@onready var state_label: Label = $StateLabel
@onready var speed_label: Label = $SpeedLabel
@onready var floor_label: Label = $FloorLabel


func _process(_delta: float) -> void:
	if not player:
		return

	var horizontal_speed: float = Vector2(player.velocity.x, player.velocity.z).length()
	speed_label.text = "Speed: %.1f m/s" % horizontal_speed
	floor_label.text = "On Floor: %s" % player.is_on_floor()


func _on_state_changed(state_name: String) -> void:
	state_label.text = "State: %s" % state_name
