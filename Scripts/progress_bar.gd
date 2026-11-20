extends ProgressBar

@export var player: CharacterBody2D

func _ready() -> void:
	if player:
		max_value = player.max_health
		print(max_value)
		value = player.current_health
		print(value)
		# Connect to a health_changed signal if your player emits one
		player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health: float) -> void:
	value = new_health
