extends CharacterBody3D

@export var color: Color = Color.RED
@export var speed = 5.0

@onready var draw_viewport: Viewport = $"/root/Game/DrawViewport"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func set_start_velocity(angle: float):
	velocity = (global_transform.basis * Vector3.FORWARD).normalized() * speed
	velocity.y = angle / speed
	
	$Mesh.get_active_material(0).albedo_color = color


func _physics_process(delta):
	velocity.y -= gravity * delta
	look_at(position + velocity)
	
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		for i: int in range(0, get_slide_collision_count()):
			var col = get_slide_collision(i)
			var uv = UVPosition.get_uv_coords(col.get_position(), col.get_normal(), true)
			if uv:
				draw_viewport.paint(uv, color)
		queue_free()
