extends CharacterBody3D

@export var mouse_sensitivity: float = 0.002

const SPEED: float = 4.0
const JUMP_FORCE: float = 8.0
const GRAVITY_FORCE: float = 0.35

const MAX_LOOK_ANGLE: float = 30.0

@onready var camera_pivot: Node3D = get_parent().get_node("CameraPivot")
@onready var camera_angle_pivot: Node3D = get_parent().get_node("CameraPivot/AnglePivot")
@onready var paint_emitter: Node3D = get_node("PaintEmitter")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		camera_angle_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_angle_pivot.rotation.x = clampf(
			camera_angle_pivot.rotation.x,
			deg_to_rad(-MAX_LOOK_ANGLE),
			deg_to_rad(MAX_LOOK_ANGLE)
			)


func _physics_process(delta):
	_apply_vertical()
	_apply_horizontal()
	
	camera_pivot.position = lerp(camera_pivot.position, position, 0.5)
	camera_pivot.rotation.y = rotation.y
	
	paint_emitter.angle = camera_angle_pivot.rotation_degrees.x
	
	move_and_slide()


func _apply_horizontal() -> void:
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	input = input.normalized()
	
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * SPEED
	velocity.z = movement_dir.z * SPEED


func _apply_vertical() -> void:
	velocity.y += -GRAVITY_FORCE
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
