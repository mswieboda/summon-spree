extends Node3D


const COLOR_PLAYER = "#ff0000"
const COLOR_CPU = "#0000ff"

var is_player = false
var is_removed = false


func _ready():
  change_color(COLOR_PLAYER if is_player else COLOR_CPU)
  rotate(Vector3.UP, randi_range(0, 360))
  translate(Vector3.UP * randf_range(-0.03, 0.015))
  $audio_die.play()


func change_color(colorHex: String):
  var material = StandardMaterial3D.new()
  material.albedo_color = Color(colorHex).darkened(0.3)
  $rotation/model/Cube.set_surface_override_material(0, material)


func _on_timer_timeout():
  is_removed = true
  queue_free()


func _on_timer_decay_timeout():
  if is_removed:
    return

  change_opacity(1 - $timer.time_left / $timer.wait_time)

func change_opacity(percent: float):
  if is_removed:
    return

  var material = StandardMaterial3D.new()
  material.albedo_color = Color(COLOR_PLAYER if is_player else COLOR_CPU).darkened(0.3 + percent * 0.3)
  $rotation/model/Cube.set_surface_override_material(0, material)
