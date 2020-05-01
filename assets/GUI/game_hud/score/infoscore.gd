extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var infoDisapear = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	if infoDisapear > 0:
		$title.percent_visible = infoDisapear
		$title/l_add_score.percent_visible = infoDisapear
		infoDisapear -= 0.8*delta
		if infoDisapear <= 0:
			$title.percent_visible = 0
			$title/l_add_score.percent_visible = 0
			$".".visible = false
		

func update_score(addScore):
	$title/l_add_score.bbcode_text = "[right][i]"+String(round(addScore))+"[/i][/right]"
	$title.percent_visible = 1
	$title/l_add_score.percent_visible = 1
	$".".visible = true
	infoDisapear = -1
	if addScore <= 0:
		infoDisapear = 2;
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
