extends Node3D


var minion_scene = preload("res://scenes/games/minion_battle/objs/minion/minion.tscn")
var is_game_over = false
var is_win = false

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
    $hud.game_over(true)
    return

  var is_cpu_game_over = $cpu/minions.get_children().any(minion_is_game_over)

  if is_cpu_game_over:
    is_game_over = true
    $hud.game_over(false)


func summon_minion(player_node : Node3D):
  var minion = minion_scene.instantiate()
  minion.is_player = player_node == $player
  player_node.get_node("minions").add_child(minion)


func _on_player_timer_timeout():
  summon_minion($player)


func _on_cpu_timer_timeout():
  summon_minion($cpu)
