extends CharacterBody3D

const SPEED = 250
const COLOR_PLAYER = "#ff0000"
const COLOR_CPU = "#0000ff"

var is_player = false
var is_dead = false
var is_game_over = false
var target_castle: Node3D = null
var target_minions = []
var attack_node: Node3D = null
var attack_damage = 30
var health = 100
var minion_dead_scene = preload("res://scenes/games/minion_battle/objs/minion_dead/minion_dead.tscn")


func _ready():
  $timer_attack.wait_time = randf_range(0.5, 1)
  var root = get_parent().get_parent().get_parent()
  var other_player_node = root.get_node("cpu" if is_player else "player")
  change_color(COLOR_PLAYER if is_player else COLOR_CPU)
  target_castle = other_player_node.get_node("castle")


func change_color(color: String):
  var material = StandardMaterial3D.new()
  material.albedo_color = Color(color)
  $model/Cube.set_surface_override_material(0, material)


func _physics_process(delta):
  if is_dead or is_game_over:
    return

  check_for_freed_minions()
  movement_and_attack(delta)


func is_valid_minion(node):
  return node and is_instance_valid(node) and not node.is_queued_for_deletion() \
    and "is_dead" in node and not node.is_dead


func check_for_freed_minions():
  target_minions = target_minions.filter(is_valid_minion)


func movement_and_attack(delta):
  if target_minions.is_empty() and target_castle:
    if movement(delta, target_castle, 3):
      is_game_over = true
  elif not target_minions.is_empty():
    # TODO: units get stuck, use path finding, or sort target_minions by distance etc
    if movement(delta, target_minions[0], 1):
      if not attack_node:
        start_attacking(target_minions[0])


func movement(delta, target: Node3D, reached_distance: int) -> bool:
  var target_position = target.global_position

  # ignore the y
  target_position.y = global_transform.origin.y

  var direction = global_transform.origin.direction_to(target_position)
  var displacement = target_position - global_transform.origin

  if displacement.length() <= reached_distance:
    return true
  else:
    velocity = direction * SPEED * delta
    move_and_slide()
    return false


func start_attacking(node: Node3D):
  attack_node = node
  $timer_attack.wait_time = randf_range(0.5, 1)
  $timer_attack.start()


func attack():
  if not attack_node or not "is_dead" in attack_node or attack_node.is_dead:
    attack_node = null
    return

  $audio_attack.pitch_scale = randf_range(0.75, 1.25)
  $audio_attack.play()
  attack_node.damage(attack_damage)

  if attack_node.is_dead:
    target_minions.erase(attack_node)
    attack_node = null
  else:
    start_attacking(attack_node)


func damage(amount: int):
  health -= amount

  if health <= 0:
    health = 0
    die()


func die():
  $audio_attack.pitch_scale = randf_range(0.75, 1.25)
  $audio_die.play()
  is_dead = true

  var minion_dead = minion_dead_scene.instantiate()
  minion_dead.is_player = is_player
  get_parent().get_parent().get_node("dead_minions").add_child(minion_dead)
  minion_dead.global_position = global_position
  queue_free()


func _on_area_attack_body_entered(body: Node3D):
  if body == self or not "is_player" in body or body.is_player == is_player or target_minions.has(body):
    return

  target_minions.append(body)


func _on_area_attack_body_exited(body):
  if body == self or not body.has_meta("is_player") or body.is_player == is_player or not target_minions.has(body):
    return

  target_minions.erase(body)


func _on_timer_attack_timeout():
  if is_dead or is_game_over:
    return

  attack()
