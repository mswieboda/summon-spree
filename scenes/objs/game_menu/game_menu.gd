extends Control

var is_game_over = false

func _process(_delta):
  if is_game_over:
    return

  if not is_game_over and Input.is_action_just_pressed("menu"):
    toggle_pause()


func game_over(is_win: bool, description: String = ""):
  is_game_over = true
  $bg/margin/vbox/title.text = "Game Over - " + ("Won!" if is_win else "Lost!")
  $bg/margin/vbox/vbox_buttons/continue.hide()
  $bg/margin/vbox/description.text = description
  $timer_game_over.start()


func toggle_pause():
  get_tree().paused = !get_tree().paused

  if visible:
    hide()
    $bg/margin/vbox/vbox_buttons/continue.hide()
    return

  $bg/margin/vbox/title.text = "Paused!"
  $bg/margin/vbox/description.text = ""
  $bg/margin/vbox/vbox_buttons/continue.show()
  focus_button()
  show()


func _on_exit_pressed():
  get_tree().paused = false
  Global.can_play_game = true
  get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_timer_game_over_timeout():
  focus_button()
  show()


func _on_continue_pressed():
  toggle_pause()


func focus_button():
  var vbox_buttons = $bg/margin/vbox/vbox_buttons

  if not vbox_buttons:
    return

  var controls = vbox_buttons.get_children().filter(func(node): return node.visible)
  var control = null if controls.is_empty() else controls[0]

  if control:
    control.grab_focus()
