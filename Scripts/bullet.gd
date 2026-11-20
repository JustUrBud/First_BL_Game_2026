extends Area2D

@export var speed: float = 10000.0
var direction: Vector2 = Vector2.ZERO
var bullet_cooldown = 1.5

func _ready() -> void:
	await get_tree().create_timer(bullet_cooldown).timeout
	queue_free()

func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		look_at(global_position + direction)
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("return")
		return
	print("banananananana")
	queue_free()
