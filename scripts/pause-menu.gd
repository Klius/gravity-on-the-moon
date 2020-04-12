extends Control

var delay_pause = 0
var Global
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global = get_node("/root/Global")

func _process(delta):
	delay_pause -= delta
	if Input.is_action_pressed("pause") and delay_pause < 0:
		back_to_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func back_to_game():
	delay_pause = 0.2
	$".".visible = !get_tree().paused
	get_tree().paused = !get_tree().paused 

func restart_level():
	back_to_game()
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Continue_pressed():
	back_to_game()


func _on_Restart_pressed():
	restart_level()
