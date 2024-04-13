extends Node3D


var minion_scene = preload("res://scenes/games/minion_battle/objs/minion/minion.tscn")
var is_game_over = false
var is_win = false
var is_paused = false

func _process(_delta):
  if is_game_over:
    return

  if not is_game_over and Input.is_action_just_pressed("menu"):
    toggle_pause()

  check_for_game_over()


func minion_is_game_over(node: Node3D):
  return "is_game_over" in node and node.is_game_over


func check_for_game_over():
  var is_player_game_over = $player/minions.get_children().any(minion_is_game_over)

  if is_player_game_over:
    is_game_over = true
    is_win = true
    $timer_game_over.start()
    return

  var is_cpu_game_over = $cpu/minions.get_children().any(minion_is_game_over)

  if is_cpu_game_over:
    is_game_over = true
    is_win = false
    $timer_game_over.start()


func summon_minion(player_node : Node3D):
  var minion = minion_scene.instantiate()
  minion.is_player = player_node == $player
  player_node.get_node("minions").add_child(minion)


func _on_player_timer_timeout():
  summon_minion($player)


func _on_cpu_timer_timeout():
  summon_minion($cpu)


func _on_timer_game_over_timeout():
  $hud/bg/margin/vbox/title.text = "Game Over!"

  if is_win:
    $hud/bg/margin/vbox/description.text = "You got to the enemy castle, you won!"
  else:
    $hud/bg/margin/vbox/description.text = "The enemy got to your castle, you lost!"

  $hud.show()


func _on_exit_pressed():
  get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func toggle_pause():
  # TODO: actually impl pausing the game
  is_paused = !is_paused

  if $hud.visible:
    $hud.hide()
    $hud/bg/margin/vbox/vbox_buttons/continue.hide()
    return

  $hud/bg/margin/vbox/title.text = "Paused!"
  $hud/bg/margin/vbox/description.text = ""
  $hud/bg/margin/vbox/vbox_buttons/continue.show()
  $hud.show()
