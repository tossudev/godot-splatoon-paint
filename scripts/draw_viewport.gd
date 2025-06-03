extends SubViewport

const UV_SIZE: int = 1024

@onready var brush: Node2D = $Brush

func paint(position : Vector2, colour := Color(1, 1, 1)):
	brush.queue_brush(position * UV_SIZE, colour)
