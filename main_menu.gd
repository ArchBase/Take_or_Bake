extends Control


var loading = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_button_toggled(toggled_on):
	if not Global.day:
		#print("To day")
		Global.day = true
	else:
		#print("To night")
		Global.day = false

func change_scene():
	get_tree().change_scene_to_file("res://loading.tscn")


func _on_start_pressed():
	print("loading")
	$day_or_night/button.text = "Loading..."
	change_scene()
