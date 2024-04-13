extends Node3D

const COLOR_PLAYER = "#ff0000"
const COLOR_CPU = "#0000ff"
var minion_scene = preload("res://scenes/games/minion_battle/objs/minion/minion.tscn")


func summon_minion(color : String, player_node : Node3D):
  var minion = minion_scene.instantiate()

  minion.change_color(color)
  minion.target = player_node.get_node("castle")
  player_node.get_node("minions").add_child(minion)

func _on_player_timer_timeout():
  summon_minion(COLOR_PLAYER, $player)


func _on_cpu_timer_timeout():
  summon_minion(COLOR_CPU, $cpu)
