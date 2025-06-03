extends Node3D

@export var paint_scene: PackedScene
@export var speed_variance: float = 1.0
@export var rotation_variance: float = 5.0

@export var emit := true
@export var paint_parent: Node3D

var rng = RandomNumberGenerator.new()
var angle: float = 0.0


func _process(_delta: float) -> void:
	emit = Input.is_action_pressed("shoot")


func _on_timer_timeout():
	if emit:
		var p = paint_scene.instantiate() as CharacterBody3D
		paint_parent.add_child(p)
		p.speed += rng.randf_range(0.0, speed_variance)
		p.global_position = global_position
		p.global_rotation = global_rotation
		p.rotate_x(deg_to_rad(angle + rng.randf_range(-rotation_variance, rotation_variance)))
		p.rotate_y(deg_to_rad(rng.randf_range(-rotation_variance, rotation_variance)))
		p.set_start_velocity(angle)
