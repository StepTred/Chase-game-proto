class_name RooftopTestLevel
extends Node3D

@onready var player: PlayerController = $Player
@onready var debug_hud: DebugHud = $DebugHud


func _ready() -> void:
	debug_hud.player = player
