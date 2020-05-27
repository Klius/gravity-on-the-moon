extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var infoDisapear = 0
enum TYPE {AIR, OVERTAKE, OVER_CAR, CHECKPOINT, OVER_RAMP, BARRIER }
var scoreLabels = null
# Called when the node enters the scene tree for the first time.
func _ready():
	scoreLabels = [$vertical/jump,$vertical/OverTake,$vertical/OverCar,$vertical/Checkpoint,$vertical/OverRamp, $vertical/Barrier]

func _process(_delta):
	pass
	
func update_score(newScore,addScore,type):
	$vertical/Score/title/l_score.bbcode_text = '[right][i]'+String(round(newScore))+'[/i][/right]'
	scoreLabels[type].update_score(addScore)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
