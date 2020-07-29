extends Control

var delay_pause = 0
var Global
var MAIN_MENU = "res://assets/level/main-menu/main-menu.tscn"
var exit = false
var canEscape = true
var disabled = false

signal enter_camera_mode
signal exit_camera_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	Global = get_node("/root/Global")
	$main/VBoxContainer/Continue.grab_focus()

func _process(delta):
	if !disabled:
		delay_pause -= delta
		if Input.is_action_pressed("pause") and delay_pause < 0 and canEscape:
			back_to_game()
		if Input.is_action_pressed("pause") and $Camera.visible:
			$Camera.disable()
			$main.visible = true
			$main/VBoxContainer/Photo.grab_focus()
			canEscape = true
			delay_pause = 0.2
			emit_signal("exit_camera_mode")
		if Global.queue.is_ready(MAIN_MENU) and exit:
			Global.set_new_scene(Global.queue.get_resource(MAIN_MENU))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func back_to_game():
	delay_pause = 0.2
	$".".visible = !get_tree().paused
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		 $main/VBoxContainer/Continue.grab_focus()

func restart_level():
	back_to_game()
# warning-ignore:return_value_discarded
	var err =get_tree().reload_current_scene()
	if (err > 0):
		Global.reload_level()

func exit_level():
	back_to_game()
	exit = true
	#get_tree().change_scene("res://assets/level/main-menu/main-menu.tscn")
	Global.load_new_scene(MAIN_MENU)
	
func _on_Continue_pressed():
	back_to_game()


func _on_Restart_pressed():
	restart_level()


func _on_Exit_pressed():
	exit_level()


func _on_Options_pressed():
	$Options.visible = true

func _on_Options_visibility_changed():
	if $Options.visible:
		$main.visible = false
		$Options/margin/body/content/sections/b_video.grab_focus()
		canEscape = false
	else :
		$main.visible = true
		canEscape = true
		$"main/VBoxContainer/Options".grab_focus()


func _on_Options_back_settings():
	$Options.visible = false


func _on_Photo_pressed():
	release_focus()
	$main.visible = false
	canEscape = false
	$Camera.enable()
	emit_signal("enter_camera_mode")
	
