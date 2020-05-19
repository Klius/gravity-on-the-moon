extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var resolutions = [Vector2(640,480),Vector2(800,600),Vector2(1024,768),Vector2(1280,720),Vector2(1920,1080)]
var current_panel = null
signal back_settings
# Called when the node enters the scene tree for the first time.
func _ready():
	current_panel = $margin/body/content/VideoPanel


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_panel(panel):
	if current_panel:
		current_panel.visible = false
	panel.visible = true
	current_panel = panel
	
func _on_b_audio_pressed():
	show_panel($margin/body/content/AudioPanel)


func _on_resolution_item_selected(id):
	get_viewport().set_size_override(true,resolutions[id])
	get_viewport().set_size_override_stretch(true)


func _on_b_fullscreen_toggled(button_pressed):
	OS.window_fullscreen = !button_pressed # Replace with function body.


func _on_b_video_pressed():
	show_panel($margin/body/content/VideoPanel)


func _on_b_Back_pressed():
#	visible = false
	emit_signal("back_settings")

func audio_set_volume(value,channel):
	if value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(channel), true)
	else:
		value = -1*((value/100)*-16+16)
		AudioServer.set_bus_mute(AudioServer.get_bus_index(channel), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(channel), value)
		

func _on_audio_General_changed(value):
	audio_set_volume(value,"Master")



func _on_SFX_changed(value):
	audio_set_volume(value,"sfx")


func _on_Music_changed(value):
	audio_set_volume(value,"music")
