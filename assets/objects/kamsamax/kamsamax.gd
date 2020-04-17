extends Spatial
enum DECALS { utande,bartatower,marsopa,popo,potorrus }
export(DECALS) var decal = DECALS.utande
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(decal == DECALS.utande):
		$"decal-SSUTANDE".visible = true
	elif(decal == DECALS.bartatower):
		$"decal-SSBARTATOWERS".visible = true
	elif(decal == DECALS.marsopa):
		$"decal-SSMARSOPA".visible = true
	elif(decal == DECALS.popo):
		$"decal-SSPOPO".visible = true
	elif(decal == DECALS.potorrus):
		$"decal-LEPOTORRUS".visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
