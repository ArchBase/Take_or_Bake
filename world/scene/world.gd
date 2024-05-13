extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Global.day:
		$WorldEnvironment.queue_free()
	else:
		$sun_light.hide()
		#$sun_reflector.light_color = Color(1, 1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
