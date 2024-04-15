extends Control


@export var speed_factor = 3
var is_done = false


func _process(delta):
  if is_done:
    return

  $bg.color.a = lerpf($bg.color.a, 0.0, delta * speed_factor)

  if is_zero_approx($bg.color.a):
    $bg.color.a = 0.0
    is_done = true
    hide()
    queue_free()
