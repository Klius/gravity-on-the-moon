extends Control

var delay_pause = 0
var Global
var MAIN_MENU = "res://assets/level/main-menu/main-menu.tscn"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global = get_node("/root/Global")
	$CenterContainer/VBoxContainer/Continue.grab_focus()

func _process(delta):
	delay_pause -= delta
	if Input.is_action_pressed("pause") and delay_pause < 0:
		back_to_game()
	if Global.queue.is_ready(MAIN_MENU):
		Global.set_new_scene(Global.queue.get_resource(MAIN_MENU))

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
	var err =get_tree().reload_current_scene()
	if (err > 0):
		Global.reload_level()

func exit_level():
	back_to_game()
	#get_tree().change_scene("res://assets/level/main-menu/main-menu.tscn")
	Global.load_new_scene(MAIN_MENU)
	
func _on_Continue_pressed():
	back_to_game()


func _on_Restart_pressed():
	restart_level()


func _on_Exit_pressed():
	exit_level()
