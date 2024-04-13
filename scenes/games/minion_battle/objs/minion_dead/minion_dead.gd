extends Node3D


const COLOR_PLAYER = "#ff0000"
const COLOR_CPU = "#0000ff"

var is_player = false


func _ready():
  change_color(COLOR_PLAYER if is_player else COLOR_CPU)


func change_color(color: String):
  var material = StandardMaterial3D.new()
  material.albedo_color = Color(color)
  $model/Cube.set_surface_override_material(0, material)


func _on_timer_timeout():
  queue_free()
