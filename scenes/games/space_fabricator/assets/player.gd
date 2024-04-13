extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var playerDir
var isFiring
var RAY_LENGTH = 1
var camera
var rayObj
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
  playerDir = get_node("player_model")
  camera = get_parent().get_node("Camera3D")
  rayObj = camera.get_node("ShootTarget")
  print(rayObj)

func _process(delta):
  if(Input.is_action_pressed("LMB")):
    isFiring = true
  else:
    isFiring = false

func _physics_process(delta):
  # Add the gravity.
  if not is_on_floor():
    velocity.y -= gravity * delta

  # Handle jump.
  if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
  var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

  point_character(direction)

  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()

func point_character(direction:Vector3):
  if (isFiring):
    var space_state = get_world_3d().direct_space_state
    var from = camera.project_ray_origin(get_viewport().get_mouse_position())
    var to = from + camera.project_ray_normal(get_viewport().get_mouse_position())
  elif(direction.length() != 0):
    playerDir.transform.basis = basis.looking_at(direction)
