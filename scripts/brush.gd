extends Node2D

@export var texture: Texture2D
@export var brush_size: int = 100

@onready var calc = $'../../ScoreCalculator'

var brush_queue: Array = []


func queue_brush(pos: Vector2, colour: Color):
	brush_queue.push_back([pos, colour])
	queue_redraw()


func _draw():
	for b in brush_queue:
		draw_texture_rect(texture, Rect2(b[0].x - brush_size/2, b[0].y - brush_size/2, brush_size, brush_size), false, b[1])
	brush_queue = []
	
	calc.recalculate_score()
