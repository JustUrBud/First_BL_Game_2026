extends CharacterBody2D

const SPEED = 2000.0 #Used for moving, higher the number faster the movement
const JUMP_VELOCITY = -1200.0 #Used for jumping, lower the number the faster the jump
@onready var sprite_2d = $Sprite2D #Used for flipping

func _physics_process(delta: float):
	var time: int = 0 #Creates local time variable, used for jumping
	
	if not is_on_floor():
		await get_tree().create_timer(time).timeout #Waits before falling depending on if the character jumped or not
		velocity += get_gravity() * delta * 2 #Does Gravity
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
	move_and_slide()
