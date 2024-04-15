extends CharacterBody3D

const SPEED = 50
const COLOR_PLAYER = "#ff0000"
const COLOR_CPU = "#0000ff"

var is_player = false
var is_dead = false
var is_game_over = false
var target_castle: Node3D = null
var target_minion: Node3D = null
var attack_node: Node3D = null
var last_attacked_by_node: Node3D = null
@export var summon_time = 1 # sec
@export var attack_target_radius = 3
@export var attack_distance = 1
@export var attack_damage = 30
@export var speed = 1
var health_max = 100
var health = health_max
var pathing_node: Node3D = null
var pathing_dir = 0
var minion_dead_scene = preload("res://scenes/games/minion_battle/objs/minion_dead/minion_dead.tscn")
@onready var battle = get_parent().get_parent().get_parent()
@export var model = preload("res://scenes/games/minion_battle/assets/3d/minion.blend")
@export var audio_attack_stream: AudioStream = null # preload("res://scenes/games/minion_battle/assets/audio/swords.mp3")
@export var audio_attack_volume: float = 0.0

func _ready():
  # model
  var model_node = model.instantiate()
  model_node.name = "model"
  $mesh.add_child(model_node)

  var shape = CylinderShape3D.new()
  shape.height = 1
  shape.radius = attack_target_radius
  $area_attack/collision.shape =  shape
  $audio_attack.stream = audio_attack_stream
  $audio_attack.volume_db = audio_attack_volume

  # timer attack
  $timer_attack.wait_time = randf_range(0.5, 1)

  var root = get_parent().get_parent().get_parent()
  var other_player_node = root.get_node("cpu" if is_player else "player")
  change_color(COLOR_PLAYER if is_player else COLOR_CPU)
  target_castle = other_player_node.get_node("castle")


func change_color(color: String):
  var material = StandardMaterial3D.new()
  material.albedo_color = Color(color)
  $mesh/model/Cube.set_surface_override_material(0, material)


func _physics_process(delta):
  if is_dead or is_game_over or battle.is_game_over:
    return

  check_for_freed_minions()
  movement_and_attack(delta)


func is_valid_minion(node):
  return node and is_instance_valid(node) \
    and not node.is_queued_for_deletion() and node.is_inside_tree() \
    and "is_dead" in node and not node.is_dead


func check_for_freed_minions():
  if not is_valid_minion(attack_node):
    attack_node = null

  if not is_valid_minion(target_minion):
    target_minion = null
    check_for_new_target_minion()

  if not is_valid_minion(pathing_node):
    pathing_node = null
    pathing_dir = 0
    check_for_new_pathing_node()


func is_in_summon_area():
  var area = get_parent().get_parent().get_node("castle/spawn/area")
  return area.get_overlapping_bodies().filter(func(node): return node == self).size() > 0

func movement_and_attack(delta):
  if is_in_summon_area() or (not target_minion and target_castle):
    if movement(delta, target_castle, 3):
      is_game_over = true
  elif target_minion:
    if movement(delta, target_minion, attack_distance):
      if not attack_node:
        start_attacking(target_minion)


func movement(delta, target: Node3D, reached_distance: int) -> bool:
  var target_position = target.global_position

  # ignore the y
  target_position.y = global_transform.origin.y

  var direction = global_transform.origin.direction_to(target_position)
  var displacement = target_position - global_position

  look_at(target_position)

  if displacement.length() <= reached_distance:
    return true
  else:
    velocity = direction * speed * SPEED * delta

    if pathing_node and pathing_dir != 0:
      velocity.z += pathing_dir * speed * SPEED * delta

    move_and_slide()
    return false


func start_attacking(node: Node3D):
  target_minion = node
  attack_node = node
  $timer_attack.wait_time = randf_range(0.5, 1)
  $timer_attack.start()


func attack():
  if not attack_node or not "is_dead" in attack_node or attack_node.is_dead:
    target_minion = null
    attack_node = null
    return

  $audio_attack.play()
  attack_node.damage(attack_damage, self)

  if attack_node.is_dead:
    target_minion = null
    attack_node = null
  else:
    start_attacking(attack_node)


func damage(amount: int, node):
  health -= amount

  $health_bar.update_health(health, health_max)

  last_attacked_by_node = node

  if attack_node != last_attacked_by_node or not attack_node:
    target_minion = node

  if health <= 0:
    health = 0
    die()


func die():
  is_dead = true

  var minion_dead = minion_dead_scene.instantiate()
  minion_dead.is_player = is_player
  get_parent().get_parent().get_node("dead_minions").add_child(minion_dead)
  minion_dead.global_position.x = global_position.x
  minion_dead.global_position.z = global_position.z
  queue_free()


func is_valid_attack_node(node):
  return is_valid_minion(node) and node != self and "is_player" in node and node.is_player != is_player


func _on_area_attack_body_entered(body: Node3D):
  if target_minion or attack_node or not is_valid_attack_node(body) or target_minion == body:
    return

  target_minion = body


func _on_area_attack_body_exited(body):
  if not target_minion == body or not is_valid_attack_node(body):
    return

  target_minion = null


func _on_timer_attack_timeout():
  if is_dead or is_game_over or battle.is_game_over:
    return

  attack()


func is_valid_pathing_node(node):
  return is_valid_minion(node) and node != self and target_minion != node and target_castle != node


func _on_area_pathing_body_entered(body):
  if pathing_node or not is_valid_pathing_node(body):
    return

  pathing_node = body
  pathing_dir = 1 if randi_range(0, 1) > 0 else -1


func _on_area_pathing_body_exited(body):
  if pathing_node != body or not is_valid_pathing_node(body):
    return

  pathing_node = null
  pathing_dir = 0

  check_for_new_pathing_node()


func sort_by_distance(a, b):
  if not is_valid_attack_node(a) or not is_valid_attack_node(b):
    return true

  var distance_to_a = a.global_position - global_position
  var distance_to_b = b.global_position - global_position
  return distance_to_a > distance_to_b


func check_for_new_target_minion():
  var bodies: Array = $area_attack.get_overlapping_bodies().filter(is_valid_attack_node)

  if not bodies.is_empty():
    bodies.sort_custom(sort_by_distance)
    target_minion = bodies[0]


func check_for_new_pathing_node():
  var bodies: Array = $area_pathing.get_overlapping_bodies().filter(is_valid_pathing_node)

  if not bodies.is_empty():
    bodies.sort_custom(sort_by_distance)
    pathing_node = bodies[0]
