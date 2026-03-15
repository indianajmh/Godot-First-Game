extends CharacterBody2D


const WALK_SPEED = 130.0
const SPRINT_SPEED = 180.0
const DASH_SPEED = 400.0
const DASH_COOLDOWN = 2.0
const DASH_DURATION = 0.15
const JUMP_VELOCITY = -300.0

var can_dash := true
var dash_timer := 0.0
var dash_ct := 0.0
var is_dashing := false
var dash_direction := 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_dashing:
		velocity.y = 0
	elif !is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply speed
	var speed = 0
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Apply movement
	if !is_dashing:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
	# Handle dash
	if !can_dash:
		dash_ct += delta
		if dash_ct >= DASH_COOLDOWN:
			can_dash = true
			dash_ct = 0
		
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_direction = direction if direction != 0 else (1.0 if !animated_sprite.flip_h else -1.0)
		is_dashing = true
		can_dash = false
		dash_timer = 0
		dash_ct = 0
		
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		dash_timer += delta
		if dash_timer >= DASH_DURATION:
			is_dashing = false

	move_and_slide()
