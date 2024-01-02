extends CharacterBody2D


const CONST_SPEED = 300.0
const JUMP_VELOCITY = -750.0
const DASH_SPEED = 1000
const DASH_LENGTH = 0.2

var DASH_COUNT = 1
var JUMP_COUNT = 1


@onready var collision_shape_2d = %CollisionShape2D
@onready var dash = $dash
@onready var sprite_2d = $Sprite2D
@export var dash_ghost : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var particles = $GPUParticles2D
@onready var p_timer = %PTimer
@onready var walkingsound = %dashSound



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	
	if (velocity.x > 1 || velocity.x < -1):
		
		sprite_2d.animation = "running"
		
	else:
		sprite_2d.animation = "default"
		
	if (velocity.y > 1):
		sprite_2d.animation = "jumping"
	elif (velocity.y < -1):
		sprite_2d.animation = "falling"
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jumping"

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or dash.is_dashing()) and JUMP_COUNT >= -1:
		JUMP_COUNT-= 1
		velocity.y = JUMP_VELOCITY
		
	if is_on_floor():
		JUMP_COUNT = 1
		DASH_COUNT = 1
		
	if Input.is_action_just_pressed("dash"):
		if DASH_COUNT > -1 or is_on_floor():
			print(JUMP_COUNT)
			JUMP_COUNT+= 1
			JUMP_COUNT+= 1
			DASH_COUNT -= 1		
			walkingsound.play()
			ghost_trail()
			
		
	var SPEED = DASH_SPEED if (dash.is_dashing() && dash.dash_available()) else CONST_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)
		

 
	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
func add_ghost():
	#print(dash_ghost)
	var ghost = dash_ghost.instantiate()
	ghost.set_property(position, $Sprite2D.scale)
	get_tree().current_scene.add_child(ghost)
 
 
func _on_ghost_timer_timeout():
	add_ghost()

	
	
func ghost_trail():
	
	dash.start_dash(DASH_LENGTH, 2)
	var tween = get_tree().create_tween()
	
	particles.emitting = true
	p_timer.start()
	tween.tween_property(self, "modulate:a", 0.5, 0.1)
	
	ghost_timer.start()
	
	if(collision_shape_2d.one_way_collision):
		tween.tween_property(self, "position:y", -20, 0.1)
	
	tween.tween_property(self, "modulate:a", 1, 0.1)



func _on_p_timer_timeout():
	particles.emitting = false
	
