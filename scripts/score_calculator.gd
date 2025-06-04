extends Node

var score := 0
var red_pixels := 0
var blue_pixels := 0

var total_pixels: int

var thread: Thread
var semaphore: Semaphore
var mutex: Mutex
var exit := false

var paint_texture: ViewportTexture


func _ready():
	paint_texture = $'../DrawViewport'.get_texture()
	
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	thread = Thread.new()
	thread.start(_thread_calculate_score)


func recalculate_score():
	await RenderingServer.frame_post_draw
	semaphore.post()


func _thread_calculate_score():
	while true:
		semaphore.wait()
		
		mutex.lock()
		var should_exit := exit
		mutex.unlock()
		
		if should_exit:
			break
		
		mutex.lock()
		var image := paint_texture.get_image()
		mutex.unlock()
		
		var size = image.get_size()
		total_pixels = size.x * size.y
		var r: int = 0
		var b: int = 0
		
		for y in range(0, size.y):
			for x in range(0, size.x):
				var pixel = image.get_pixel(x, y)
				if pixel.r >= 0.5:
					r += 1
				if pixel.b >= 0.5:
					b += 1
		
		# Only update score values when calculation is finished
		mutex.lock()
		
		red_pixels = r
		blue_pixels = b
		score = red_pixels + blue_pixels
		
		mutex.unlock()


func _exit_tree():
	mutex.lock()
	exit = true
	mutex.unlock()
	
	semaphore.post()
	thread.wait_to_finish()
