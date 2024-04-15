extends CharacterBody3D

var isReady = false
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var target
var health = 3
var damage_target

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
  $Timer.start()
  #target = get_node("fabricator")
  #global_transform.basis.looking_at(target.transform.origin)
  pass

func _physics_process(delta):

  if(!isReady):
    return

  # Add the gravity.
  if not is_on_floor():
    velocity.y -= gravity * delta


  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  look_at(target.transform.origin)
  var input_dir = self.global_transform.basis.z
  var direction = -input_dir #(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()

func set_target(aimAt:Node3D):
  target = aimAt

func _on_timer_timeout():
  isReady = true
  $black_hole.visible = false
  pass # Replace with function body.

func do_damage():
  health -= 1
  if (health == 0 ):
    get_parent().get_parent().despawn(self)


func _on_damage_timer_timeout():
  damage_target.take_damage()

  pass # Replace with function body.


func _on_area_3d_body_entered(body):
  if (body.name.contains("fabricator")):
    damage_target = body
    $damage_timer.start()
  pass # Replace with function body.
