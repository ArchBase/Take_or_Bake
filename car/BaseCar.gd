extends VehicleBody3D


@export var STEER_SPEED = 2
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
var left = 0
var right = 0
var stop = false

func process_AI():
	if $left.is_colliding() and $center.is_colliding():
		left = 0
		right = 1
	else:
		right = 0
	if $right.is_colliding() and $center.is_colliding():
		right = 0
		left = 1
	else:
		left = 0
	if $right.is_colliding() and $left.is_colliding():
		right = 0
		left = 0
	if $right.is_colliding() and $left.is_colliding() and $center.is_colliding():
		stop = true
	print($left.is_colliding(), $center.is_colliding(), $right.is_colliding())

func _physics_process(delta):
	process_AI()
	var speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	traction(speed)
	$Hud/speed.text=str(round(speed*3.8))+"  KMPH"

	var fwd_mps = transform.basis.x.x
	#steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target = left - right
	#print(steer_target)
	steer_target *= STEER_LIMIT
	#if Input.is_action_pressed("ui_up"):
	#print(speed > 0.000001)
	if speed > 3:
		engine_force = 0
	else:
		#stop = false
		#print("not")
		if not stop:
		#if Input.is_action_pressed("ui_up"):
				engine_force = -engine_force_value
		else:
			brake = 0.0
			
	#if Input.is_action_pressed("ui_select"):
	if stop:
		engine_force = 0
		brake=3

	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
	#print($center.is_colliding())



func traction(speed):
	apply_central_force(Vector3.DOWN*speed)




