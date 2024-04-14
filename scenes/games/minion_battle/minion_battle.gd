extends Node3D

const MAX_MINIONS = 15

var minion_arms_scene = preload("res://scenes/games/minion_battle/objs/minion_arms/minion_arms.tscn")
var minion_archer_scene = preload("res://scenes/games/minion_battle/objs/minion_archer/minion_archer.tscn")
var is_game_over = false
var is_win = false
var player_spawn_type = "arms"

func _process(_delta):
  if is_game_over:
    return

  check_for_game_over()


func minion_is_game_over(node: Node3D):
  return "is_game_over" in node and node.is_game_over


func check_for_game_over():
  var is_player_game_over = $player/minions.get_children().any(minion_is_game_over)

  if is_player_game_over:
    is_game_over = true
    $menu.game_over(true)
    return

  var is_cpu_game_over = $cpu/minions.get_children().any(minion_is_game_over)

  if is_cpu_game_over:
    is_game_over = true
    $menu.game_over(false)


func summon_minion(player_node : Node3D):
  if is_game_over:
    return

  if player_node.get_node("minions").get_child_count() >= MAX_MINIONS:
    return

  if player_node.get_node("castle/spawn/area").get_overlapping_bodies().size() > 0:
    return

  var minion_scene = minion_arms_scene

  if player_node == $player and player_spawn_type == "archer":
    minion_scene = minion_archer_scene

  var minion = minion_scene.instantiate()
  minion.is_player = player_node == $player
  player_node.get_node("minions").add_child(minion)
  minion.global_position = player_node.get_node("castle/spawn").global_position


func _on_player_timer_timeout():
  summon_minion($player)


func _on_cpu_timer_timeout():
  summon_minion($cpu)



func _on_arms_button_toggled(toggled_on):
  if toggled_on:
    $hud/margin/vbox/hbox/buttons/archer_button.button_pressed = false
    player_spawn_type = "arms"
    $player/timer.wait_time = 1
  else:
    $hud/margin/vbox/hbox/buttons/archer_button.button_pressed = true

func _on_archer_button_toggled(toggled_on):
  if toggled_on:
    $hud/margin/vbox/hbox/buttons/arms_button.button_pressed = false
    player_spawn_type = "archer"
    $player/timer.wait_time = 2
  else:
    $hud/margin/vbox/hbox/buttons/arms_button.button_pressed = true
