extends VehicleBody3D


const MOUSE_SENSITIVITY = 0.5
@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
var light_on = true

func _unhandled_input(event):
	if event is InputEventMouseMotion and Global.in_car:
		#print($look.rotation_degrees)
		var prev_x = rotation_degrees.x
		$SpringArm3D.rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY
		$SpringArm3D.rotation_degrees.x -= event.relative.y * MOUSE_SENSITIVITY
		if rotation_degrees.x > 13.0 or rotation_degrees.x < -40.0:
			rotation_degrees.x = prev_x
	
func _physics_process(delta):

	if not Global.in_car:
		return
	var speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	traction(speed)
	$Hud/speed.text=str(round(speed*3.8))+"  KMPH"

	var fwd_mps = transform.basis.x.x
	steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	steer_target *= STEER_LIMIT
	if Input.is_action_just_pressed("switch_light"):
		if not light_on:
			$headlights/SpotLight3D2.show()
			$headlights/SpotLight3D3.show()
			light_on = true
		else:
			$headlights/SpotLight3D2.hide()
			$headlights/SpotLight3D3.hide()
			light_on = false
	if Input.is_action_pressed("reverse"):
		$brake_light/SpotLight3D2.show()
		$brake_light/SpotLight3D3.show()
	# Increase engine force at low speeds to make the initial acceleration faster.

		if speed < 20 and speed != 0:
			engine_force = clamp(engine_force_value * 3 / speed, 0, 300)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0
	if Input.is_action_pressed("forward"):
		$brake_light/SpotLight3D2.hide()
		$brake_light/SpotLight3D3.hide()
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = -clamp(engine_force_value * 10 / speed, 0, 300)
			else:
				engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
		
	if Input.is_action_pressed("ui_select"):
		$brake_light/SpotLight3D2.show()
		$brake_light/SpotLight3D3.show()
		brake=3
		$wheal2.wheel_friction_slip=0.8
		$wheal3.wheel_friction_slip=0.8
	else:
		$brake_light/SpotLight3D2.hide()
		$brake_light/SpotLight3D3.hide()
		$wheal2.wheel_friction_slip=3
		$wheal3.wheel_friction_slip=3
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)



func traction(speed):
	apply_central_force(Vector3.DOWN*speed)

func _process(_delta):
	#print(Global.in_car)
	if Input.is_action_just_pressed("enter_in_car"):
		Global.in_car = not Global.in_car
		if Global.in_car:
			$"../CharacterBody3D".position = Vector3(99, 99, 99)
			$look/Camera3D.make_current()
		else:
			$"../CharacterBody3D".position = position
			$"../CharacterBody3D/SpringArm3D/Camera3D".make_current()
	

