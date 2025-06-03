extends MeshInstance3D

@onready var viewport = get_node("/root/Game/DrawViewport")


func _ready() -> void:
	UVPosition.set_mesh(self)
	(mesh.surface_get_material(0) as ShaderMaterial).set_shader_parameter("Paint", viewport.get_texture())
