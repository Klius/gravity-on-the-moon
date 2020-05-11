extends Control

signal start_new_game
signal close_game
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/b-new-game".grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_bnewgame_pressed():
	print("new game click")
	emit_signal("start_new_game")


func _on_bexit_pressed():
	emit_signal("close_game")


func _on_boptions_pressed():
	$Options.visible = true


func _on_Options_visibility_changed():
	if $Options.visible:
		$Options/margin/body/content/sections/b_video.grab_focus()
	else :
		$"VBoxContainer/b-options".grab_focus()
