extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var blinkout = 0.2
var mesh 

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh = $"LuzA/LuzA".mesh

func _process(delta):
	blinkout -= delta
	if blinkout < 0:
		var mat = mesh.surface_get_material(0)
		mat.flags_unshaded = !mat.flags_unshaded
		blinkout = 0.5
		$".".get_node("LuzB/LuzB").material_override = mat
		#$"LuzB/LuzB".material_override = mat
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
