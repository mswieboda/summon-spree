extends Node3D


const COLOR_PLAYER = "#ff0000"
const COLOR_CPU = "#0000ff"

var is_player = false


func _ready():
  change_color(COLOR_PLAYER if is_player else COLOR_CPU)
  rotate(Vector3.UP, randi_range(0, 360))
  translate(Vector3.UP * randf_range(-0.03, 0.015))


func change_color(colorHex: String):
  var material = StandardMaterial3D.new()
  material.albedo_color = Color(colorHex).darkened(0.3)
  $rotation/model/Cube.set_surface_override_material(0, material)


func _on_timer_timeout():
  queue_free()


func _on_timer_decay_timeout():
  change_opacity()

func change_opacity():
  var color = $rotation/model/Cube.get_surface_override_material(0).albedo_color
  var material = StandardMaterial3D.new()
  material.albedo_color = color.darkened(0.3)
  $rotation/model/Cube.set_surface_override_material(0, material)
