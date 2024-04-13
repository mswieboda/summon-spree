extends Node3D


var minion_scene = preload("res://scenes/games/minion_battle/objs/minion/minion.tscn")


func summon_minion(player_node : Node3D):
  var minion = minion_scene.instantiate()
  minion.is_player = player_node == $player
  player_node.get_node("minions").add_child(minion)


func _on_player_timer_timeout():
  summon_minion($player)


func _on_cpu_timer_timeout():
  summon_minion($cpu)
