extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (bool) var makeVisible = false
export (NodePath) var nodeToHide 
# Called when the node enters the scene tree for the first time.
func _ready():
	nodeToHide = get_node(nodeToHide)
	connect("body_entered",self,"hide_body_entered")
	
func hide_body_entered(body):
	if body.get_name() == "Car":
		nodeToHide.visible = makeVisible

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
