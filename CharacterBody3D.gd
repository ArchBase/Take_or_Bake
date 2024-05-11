extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var prev_x = rotation_degrees.x
		rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY
		rotation_degrees.x += event.relative.y * MOUSE_SENSITIVITY
		if rotation_degrees.x > 13.0 or rotation_degrees.x < -40.0:
			rotation_degrees.x = prev_x
		print(rotation_degrees)
		#rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		
		#rotation_degrees.y -= event.relative.y * MOUSE_SENSITIVITY
		#rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#print(input_dir.x)
	input_dir.x *= -1
	var direction = (transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
