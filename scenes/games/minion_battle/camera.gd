extends Camera3D

const SPEED : float = 15
const BOOST_SPEED_MULTIPLIER : float = 3.0

func _process(delta):
  if not current:
    return

  var direction = Vector3(
    float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
    0,
    float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
  ).normalized()

  direction = direction.rotated(Vector3.UP, deg_to_rad(-45))

  if Input.is_physical_key_pressed(KEY_SHIFT): # boost
    global_translate(direction * SPEED * delta * BOOST_SPEED_MULTIPLIER)
  else:
    global_translate(direction * SPEED * delta)
