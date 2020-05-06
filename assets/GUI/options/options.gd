extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var resolutions = [Vector2(640,480),Vector2(800,600),Vector2(1024,768),Vector2(1280,720),Vector2(1920,1080)]
var current_panel = null
# Called when the node enters the scene tree for the first time.
func _ready():
	current_panel = $"MarginContainer/VBoxContainer/HBoxContainer/VideoPanel"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_panel(panel):
	if current_panel:
		current_panel.visible = false
	panel.visible = true
	current_panel = panel
	
func _on_b_audio_pressed():
	show_panel($MarginContainer/VBoxContainer/HBoxContainer/AudioPanel)


func _on_resolution_item_selected(id):
	get_viewport().set_size_override(true,resolutions[id])
	get_viewport().set_size_override_stretch(true)


func _on_b_fullscreen_toggled(button_pressed):
	OS.window_fullscreen = !button_pressed # Replace with function body.


func _on_b_video_pressed():
	show_panel($MarginContainer/VBoxContainer/HBoxContainer/VideoPanel)


func _on_b_Back_pressed():
	visible = false
