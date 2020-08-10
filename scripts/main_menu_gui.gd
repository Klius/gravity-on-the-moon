extends Control

signal start_new_game
signal close_game
var fade_out = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/b-new-game".grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_progress(_progress: float):
	$LoadingScreen.set_progress(_progress)

func _on_bnewgame_pressed():
	var rectangle = Rect2($"VBoxContainer/b-new-game".rect_global_position,$"VBoxContainer/b-new-game".rect_size)
	rectangle.position.x += $"VBoxContainer/b-new-game".rect_size.x
	$Popup.popup(rectangle)
	


func _on_bexit_pressed():
	emit_signal("close_game")


func _on_boptions_pressed():
	$Options.visible = true
	$"VBoxContainer".visible = false


func _on_Options_visibility_changed():
	if $Options.visible:
		$Options/margin/body/content/sections/b_video.grab_focus()
	else :
		$"VBoxContainer/b-options".grab_focus()


func _on_Options_back_settings():
	$Options.visible = false
	$"VBoxContainer".visible = true
	$"VBoxContainer/b-options".grab_focus()


func _on_btimedride_pressed():
	$Popup.visible = false
	emit_signal("start_new_game", true)
	$LoadingScreen.visible = true
	$"VBoxContainer".visible = false

func _on_bfreeride_pressed():
	$Popup.visible = false
	emit_signal("start_new_game", false)
	$LoadingScreen.visible = true
	$"VBoxContainer".visible = false
