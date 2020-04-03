extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal overtakeBody 
signal jumpBody 
var over_cooldown = 0
var jump_cooldown = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	over_cooldown -= delta
	jump_cooldown -= delta
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

