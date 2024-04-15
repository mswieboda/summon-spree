extends Node3D

const SPEED = 30
const MAX_DEG = -69.0
const ANGLE_APPROX_PADDING = 1
var is_attacking = false
var has_attacked = false


func _physics_process(delta):
  if not is_attacking:
    return

  var angle = 0.0 if has_attacked else MAX_DEG
  $sword.rotation_degrees.z = lerpf($sword.rotation_degrees.z, angle, delta * SPEED)

  if not has_attacked:
    if $sword.rotation_degrees.z <= angle + ANGLE_APPROX_PADDING:
      $sword.rotation_degrees.z = angle
      has_attacked = true
  elif $sword.rotation_degrees.z >= angle - ANGLE_APPROX_PADDING:
    $sword.rotation_degrees.z = angle
    is_attacking = false
    has_attacked = false


func attack():
  is_attacking = true
