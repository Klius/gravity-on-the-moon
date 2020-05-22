extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var global
var screen
var current_panel = null
signal back_settings
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/PlayerVariables")
	global = get_node("/root/Global")
	screen = get_node("/root/screen")
	init()

func init():
	$margin/body/content/AudioPanel/VBoxContainer/General/slider.value = player.settings["a_master"]
	$margin/body/content/AudioPanel/VBoxContainer/Music/slider.value = player.settings["a_music"]
	$margin/body/content/AudioPanel/VBoxContainer/SFX/slider.value = player.settings["a_sfx"]
	$margin/body/content/VideoPanel/VBoxContainer/FOV/slider.value = player.settings["fov"]
	$margin/body/content/VideoPanel/VBoxContainer/View_Distance/slider.value = player.settings["far"]
	$margin/body/content/VideoPanel/VBoxContainer/res/resolution.selected = player.settings["res"]
	$margin/body/content/VideoPanel/VBoxContainer/fullscreen/b_fullscreen.pressed = player.settings["window"]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_panel(panel):
	if current_panel:
		current_panel.visible = false
	if panel:
		panel.visible = true
		current_panel = panel

func _on_b_audio_pressed():
	show_panel($margin/body/content/AudioPanel)
	$margin/body/content/AudioPanel/VBoxContainer/General/slider.grab_focus()


func _on_resolution_item_selected(id):
	player.settings["res"] = id
	if player.settings["window"]:
		screen.base_size = player.resolutions[id]
		screen.set_windowed()
	else:
		$margin.visible = false
		$black.visible = true
		yield(get_tree().create_timer(1.0), "timeout") 
		screen.base_size = player.resolutions[id]
		screen.set_fullscreen()
		$black.visible = false
		$margin.visible = true
#	get_viewport().set_size_override(true,resolutions[id])
#	get_viewport().set_size_override_stretch(true)


func _on_b_fullscreen_toggled(button_pressed):
	player.settings["window"] = button_pressed
	if button_pressed:
		screen.set_windowed()
	else:
		screen.set_fullscreen()

func _on_b_video_pressed():
	show_panel($margin/body/content/VideoPanel)
	$margin/body/content/VideoPanel/VBoxContainer/res/resolution.grab_focus()


func _on_b_Back_pressed():
#	visible = false
	player.save_game()
	emit_signal("back_settings")


func _on_audio_General_changed(value):
	global.audio_set_volume(value,"Master")
	player.settings["a_master"] = value



func _on_SFX_changed(value):
	global.audio_set_volume(value,"sfx")
	player.settings["a_sfx"] = value


func _on_Music_changed(value):
	global.audio_set_volume(value,"music")
	player.settings["a_music"] = value


func _on_b_category_focus_entered():
	show_panel(null)


func _on_FOV_changed(value):
	global.camera_set_fov(value)
	player.settings["fov"] = value


func _on_View_Distance_changed(value):
	global.camera_set_far(value)
	player.settings["far"] = value


func _on_b_category_mouse_entered():
	pass # Replace with function body.
