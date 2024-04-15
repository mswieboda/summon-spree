extends Node3D

const MAX_MINIONS = 15

var minion_arms_scene = preload("res://scenes/games/minion_battle/objs/minion_arms/minion_arms.tscn")
var minion_archer_scene = preload("res://scenes/games/minion_battle/objs/minion_archer/minion_archer.tscn")
var is_game_over = false
var is_win = false
var player_summon_type = "arms"


func _ready():
  set_player_summon_type("arms")


func _process(delta):
  if is_game_over:
    return

  lower_spawn_fog($player, delta)
  lower_spawn_fog($cpu, delta)
  check_for_player_summon_type()
  check_for_game_over()


func lower_spawn_fog(playerNode, delta):
  var fog = playerNode.get_node("castle/spawn/fog")

  if fog.material.density > 0:
    fog.material.density = lerpf(fog.material.density, 0.0, delta)


func minion_is_game_over(node: Node3D):
  return "is_game_over" in node and node.is_game_over


func check_for_player_summon_type():
  if Input.is_action_just_pressed("switch_summon"):
    if $hud/margin/vbox/hbox/buttons/arms_button.button_pressed:
      $hud/margin/vbox/hbox/buttons/arms_button.button_pressed = false
      $hud/margin/vbox/hbox/buttons/archer_button.button_pressed = true
      set_player_summon_type("archer")
    elif $hud/margin/vbox/hbox/buttons/archer_button.button_pressed:
      $hud/margin/vbox/hbox/buttons/archer_button.button_pressed = false
      $hud/margin/vbox/hbox/buttons/arms_button.button_pressed = true
      set_player_summon_type("arms")


func check_for_game_over():
  var is_player_game_over = $player/minions.get_children().any(minion_is_game_over)

  if is_player_game_over:
    is_game_over = true
    $game_menu.game_over(true, "You got to the enemy castle!")
    return

  var is_cpu_game_over = $cpu/minions.get_children().any(minion_is_game_over)

  if is_cpu_game_over:
    is_game_over = true
    $game_menu.game_over(false, "The enemy got to your castle!")


func get_new_minion(is_player: bool = true):
  var minion_scene = minion_arms_scene

  if is_player and player_summon_type == "archer":
    minion_scene = minion_archer_scene

  return minion_scene.instantiate()


func summon_minion(player_node : Node3D):
  if is_game_over:
    return

  if player_node.get_node("minions").get_child_count() >= MAX_MINIONS:
    return

  if player_node.get_node("castle/spawn/area").get_overlapping_bodies().size() > 0:
    return

  player_node.get_node("castle/spawn/fog").material.density = 1.3

  var is_player = player_node == $player
  var minion = get_new_minion(is_player)
  minion.is_player = is_player
  player_node.get_node("minions").add_child(minion)
  minion.global_position = player_node.get_node("castle/spawn").global_position


func _on_player_timer_timeout():
  summon_minion($player)


func _on_cpu_timer_timeout():
  summon_minion($cpu)


func _on_arms_button_toggled(toggled_on):
  if toggled_on:
    $hud/margin/vbox/hbox/buttons/archer_button.button_pressed = false
    set_player_summon_type("arms")
  else:
    $hud/margin/vbox/hbox/buttons/archer_button.button_pressed = true


func _on_archer_button_toggled(toggled_on):
  if toggled_on:
    $hud/margin/vbox/hbox/buttons/arms_button.button_pressed = false
    set_player_summon_type("archer")
  else:
    $hud/margin/vbox/hbox/buttons/arms_button.button_pressed = true


func set_player_summon_type(spawn_type: String):
  $hud/audio_snap.play()
  player_summon_type = spawn_type

  var label = $hud/margin/vbox/hbox_instructions/summon_instructions
  var minion = get_new_minion()

  $player/timer.wait_time = minion.summon_time

  var text = "summon: {summon} sec\nrange: {range} m\ndamage: {damage}\nspeed: {speed}"
  label.text = text.format({
    "summon": minion.summon_time,
    "range": minion.attack_target_radius,
    "damage": minion.attack_damage,
    "speed": minion.speed,
  })
