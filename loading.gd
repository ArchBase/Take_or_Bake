extends Node3D

var time = 0
var do = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#get_tree().change_scene_to_file("res://world/scene/world.tscn")

func _process(_delta):
	time += _delta
	if time > 1 and do:
		do = false
		print("Open world")
		get_tree().change_scene_to_file("res://world/scene/world.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
