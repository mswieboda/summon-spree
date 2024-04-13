extends CharacterBody3D

const SPEED = 150

var target: Node3D = null

func change_color(color: String):
  var material = StandardMaterial3D.new()

  material.albedo_color = Color(color)

  $model/Cube.set_surface_override_material(0, material)


func _physics_process(delta):
  movement(delta)


func movement(delta):
  var target_position = target.global_position
  var direction = global_transform.origin.direction_to(target_position)
  var displacement = target_position - global_transform.origin

  if displacement.is_zero_approx():
    # stop
    # TODO: attack castle
    pass
  else:
    velocity = -direction * SPEED * delta
    move_and_slide()
