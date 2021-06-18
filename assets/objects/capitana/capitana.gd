extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 500 
var direction = Vector3.BACK
var ttl = 10
signal hit_capitana
export var DEBUG = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#func _process(delta):
#	if !DEBUG:
#		ttl -= delta
#		if ttl < 0 :
#			$".".queue_free()
#
#func _init(speed, direction):
#	speed = speed
#	direction = direction
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func _physics_process(delta):
#	add_force(direction*delta*speed,global_transform.origin)


func _on_capitana_body_entered(body):
	if body.get_name() == "Car":
		emit_signal("hit_capitana")


func _on_capitana_sleeping_state_changed():
	pass#emit_signal("hit_capitana")
