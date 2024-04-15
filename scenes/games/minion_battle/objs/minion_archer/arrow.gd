extends Node3D

var SPEED = 50
var is_dead = false

func _physics_process(delta):
  if is_dead:
    return

  translate(Vector3(0, 0, -delta * SPEED))


func _on_remove_timer_timeout():
  is_dead = true
  queue_free()
