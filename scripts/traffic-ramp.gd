extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal overtakeBody 
signal jumpBody 
signal overRamp
var over_cooldown = 0
var jump_cooldown = 0
var ramp_cooldown = 0
export(Color) var body_color = Color(0.090196, 0.266667, 0.160784)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_body_color():
	var body = $mesh.get_mesh().surface_get_material(0).duplicate()
	body.set_albedo(body_color)
	$mesh.get_mesh().surface_set_material(0,body)

func _process(delta):
	over_cooldown -= delta
	jump_cooldown -= delta
	ramp_cooldown -= delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func disableAreas():
	$areas/jumpArea/col.disabled = 1
	$areas/overtakeArea/col.disabled = 1



func _on_jumpArea_body_entered(body):
	if(body.get_name() == "Car" && jump_cooldown <0 ):
		emit_signal("jumpBody",body)
		jump_cooldown = 5


func _on_overtakeArea_body_entered(body):
	if(body.get_name() == "Car" && over_cooldown < 0):
		emit_signal("overtakeBody",body)
		over_cooldown = 5 


func _on_traffic_body_entered(body):
	if (body.get_name() == "Car" ):
		disableAreas()
 



func _on_rampArea_body_entered(body):
	if(body.get_name() == "Car" && ramp_cooldown < 0):
		emit_signal("overRamp")
		ramp_cooldown = 5 
