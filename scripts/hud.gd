extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score_to_add = 0
var overtake_score = 0
var jumpcar_score = 0
var air_score = 0
var on_air_points = 0
var player_vars = null
#AIR POINTS
var cur_rot = Vector3(0,0,0)
var rot_so_far = Vector3(0,0,0)
var old_rot = Vector3(0,0,0)
var flips = 1;
# Called when the node enters the scene tree for the first time.
func _ready():
	player_vars = get_node("/root/PlayerVariables")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	checkScores()
	#pass#$Label.text = "\nfps:"+ String(Engine.get_frames_per_second() )
	
func checkScores():
	if overtake_score > 0:
		overtake_score -= 0.5
		player_vars.score += 0.5 
		$Score.update_score(player_vars.score,overtake_score,$Score.TYPE.OVERTAKE)
	if air_score > 0 :
		air_score -= 0.5
		player_vars.score += 0.5 
		$Score.update_score(player_vars.score,air_score,$Score.TYPE.AIR)
	if jumpcar_score > 0 :
		jumpcar_score -= 0.5
		player_vars.score += 0.5 
		$Score.update_score(player_vars.score,jumpcar_score,$Score.TYPE.OVER_CAR)

func _on_Car_update_kph(kph,max_kph):
	$brcontainer/speedometer.update_speedometer(kph,max_kph)

func _on_traffic_overtakeBody(body):
	overtake_score += 150


func _on_traffic_jumpBody(body):
	jumpcar_score += 500
	
func _on_Car_on_air(car):
	on_air_points += 0.1
	cur_rot = car.rotation_degrees
	rot_so_far += old_rot - cur_rot;
	old_rot = cur_rot;
	#if ceil(abs($Car.rotation_degrees.z))>= 180 :
	#	flips += 1
	if ceil(abs(rot_so_far.x)) >= 180 :
		flips += 1
		rot_so_far.x = 0
	if ceil(abs(rot_so_far.z)) >= 180 :
		flips += 1
		rot_so_far.z = 0
	#print("Rotation: "+String(rot_so_far)+ " flips:"+String(flips))
	print("onair: "+String(on_air_points))


func _on_Car_on_air_over():
	cur_rot = Vector3(0,0,0)
	rot_so_far = Vector3(0,0,0)
	old_rot = Vector3(0,0,0)
	print("onair: "+String(on_air_points)+"x"+String(flips*0.5)+"  Total:"+String(round(on_air_points *(flips * 0.5))))
	air_score += round(on_air_points *(flips * 0.5))
	on_air_points = 0
	flips = 1
