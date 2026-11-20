extends CharacterBody2D

const SPEED = 3000.0 #Used for moving, higher the number faster the movement
const JUMP_VELOCITY = -2500.0 #Used for jumping, lower the number the faster the jump
var spike = false
@onready var sprite_2d = $Sprite2D #Used for flipping
@export var health = 5
@export var bullet_scene: PackedScene
var active_bullet: Node = null 
var cooldown = 1.5

func _physics_process(delta: float):
	var time: int = 0 #Creates local time variable, used for jumping
	
	if not is_on_floor():
		await get_tree().create_timer(time).timeout #Waits before falling depending on if the character jumped or not
		velocity += get_gravity() * delta * 4 #Does Gravity
		time = 0

	if Input.is_action_just_pressed("ui_up") and is_on_floor(): #Checks if up arrowis pressed amd if on ground
		time = 1
		velocity.y = JUMP_VELOCITY * 2
	
	var direction := Input.get_axis("ui_left", "ui_right") #checks arrows
	
	if direction:

		if velocity.x > 0:
			sprite_2d.flip_h = false #Flips to face right
		elif velocity.x < 0:
			sprite_2d.flip_h = true #Flips to face left

		velocity.x = direction * SPEED #Movement direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) #Moves (Start, Direction, Speed)
	
	if health <= 0:
		queue_free()
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	spike = true
	while spike == true:
		health -= .1
		$CanvasLayer/ProgressBar.value = health
		await get_tree().create_timer(.2).timeout

func _on_area_2d_body_exited(body: Node2D) -> void:
	spike = false
	health = snappedf(health, 0.5)
	$CanvasLayer/ProgressBar.value = health
	print(health)
	pass


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):
		if not is_instance_valid(active_bullet):
			shoot()
			run_cooldown()

func shoot() -> void:
	if bullet_scene == null:
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	active_bullet = bullet 
	
	bullet.global_position = $Marker2D.global_position
	bullet.direction = global_position.direction_to(get_global_mouse_position())

func run_cooldown() -> void:
	while cooldown >= 0:
		await get_tree().create_timer(.1).timeout
		cooldown -= .1
		$CanvasLayer2/ProgressBar.value = cooldown
	cooldown = 1.5
	$CanvasLayer2/ProgressBar.value = cooldown
