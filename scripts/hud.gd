extends CanvasLayer

const LERP_WEIGHT: float = 0.1

@onready var score_calculator: Node = get_parent().get_node("ScoreCalculator")

var score: int
var total: int

var red_score: int
var blue_score: int

var percentage_painted: float


func _process(_delta: float) -> void:
	score = lerp(score, score_calculator.score, LERP_WEIGHT)
	total = score_calculator.total_pixels
	
	red_score = score_calculator.red_pixels
	blue_score = lerp(blue_score, score_calculator.blue_pixels, LERP_WEIGHT)
	
	if total == 0:
		return
	
	percentage_painted = snappedf(float(score) / float(total) * 100.0, 0.1)
	_update_ui()


func _update_ui() -> void:
	$ScoreTotal.set_text("Total Area Painted: " + str(percentage_painted) + "%")
	$ScoreBar.set_max(score)
	$ScoreBar.set_value(blue_score)
