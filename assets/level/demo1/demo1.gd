extends Spatial
###############################
#Loading stuff

export var NEXT_LEVEL = "res://assets/level"
##############################
## Player stuff
var on_air_points = 0
var player_vars
var Global
# Called when the node enters the scene tree for the first time.
func _ready():
	player_vars = get_node("/root/PlayerVariables")
	Global = get_node("/root/Global")
	#$AnimationPlayer.play("traffic")
func _process(_delta):
	if Global.queue.is_ready(NEXT_LEVEL):
		Global.set_new_level(Global.queue.get_resource(NEXT_LEVEL),$Car.get_linear_velocity(), $Car.get_angular_velocity())	
		
		
func _physics_process(_delta):
	pass
	

func _on_Area_body_entered(body):
	pass
	if (body.get_name() == "Car"):
		$AudioStreamPlayer.play()
		


func _on_Area_body_exited(body):
	if (body.get_name() == "Car"):
		$AudioStreamPlayer.set_bus("Audio")


func _on_Car_on_air():
	on_air_points += 0.1
	print("onair: "+String(on_air_points))


func _on_Car_on_air_over():
	player_vars.score += round(on_air_points)
	on_air_points = 0
	$HUD/RichTextLabel/l_score.bbcode_text = "[right][i]"+String(player_vars.score)+"[/i][/right]"


func _on_traffic_overtakeBody(body):
	player_vars.score += 999
	$HUD/RichTextLabel/l_score.bbcode_text = "[right][i]"+String(player_vars.score)+"[/i][/right]"


func _on_traffic_jumpBody(body):
	player_vars.score += 500
	$HUD/RichTextLabel/l_score.bbcode_text = "[right][i]"+String(player_vars.score)+"[/i][/right]"



func _on_load_body_entered(body):
	if (body.get_name() == "Car"):
		Global.load_new_scene(NEXT_LEVEL)
		#get_tree().change_scene(NEXT_LEVEL)




func _on_MusicStart_body_entered(body):
	if (body.get_name() == "Car"):
		$AudioStreamPlayer.play()
