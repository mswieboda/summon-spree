extends Control

@export var DEBUG = true

var is_ready = false
@onready var game_list = $games_page/vbox/vbox_buttons/game_list


func _ready():
  is_ready = true
  focus_button($title_page)


func _process(_delta):
  if not DEBUG:
    return

  if $games_page.visible and Input.is_action_just_pressed("menu_debug_next"):
    select_next_game()


func _on_start_button_pressed():
  $audio_snap.play()
  $title_page.hide()
  $games_page.show()
  focus_button($games_page)


func _on_exit_button_pressed():
  $audio_snap.play()
  get_tree().quit()


func _on_visibility_changed():
  if not $title_page or not $games_page or not is_ready:
    return

  if visible:
    var page: MarginContainer = $title_page if $title_page.visible else $games_page
    focus_button(page)


func focus_button(page: MarginContainer):
  var vbox_buttons = page.get_node("vbox/vbox_buttons")

  if not vbox_buttons:
    return

  if page == $games_page:
    vbox_buttons.get_node("game_list").get_child(0).toggle_select()

  var control: Control = vbox_buttons.get_child(1 if page == $games_page else 0)

  if control is Control:
    control.grab_focus()


func _on_back_button_pressed():
  $audio_snap.play()
  $games_page.hide()
  $title_page.show()
  focus_button($title_page)


func start_game():
  var games = game_list.get_children()
  var selected_games = games.filter(func(node): return node.selected)
  var selected_game = null if selected_games.is_empty() else selected_games[0].text
  var scene = null

  if selected_game == "Minion Battle":
    scene = "res://scenes/games/minion_battle/minion_battle.tscn"
  elif selected_game == "Space Fabricator":
    scene = "res://scenes/games/space_fabricator/space_fabricator_main.tscn"
  elif selected_game == "Jury Summons":
    scene = "res://scenes/games/jury_summons/jury_sum_main.tscn"

  if scene:
    get_tree().change_scene_to_file(scene)


func _on_summon_button_pressed():
  $audio_snap.play()
  toggle_disabled()

  if DEBUG:
    start_game()
  else:
    $summon_timer.start(randf_range(3, 5))
    $selection_change_timer.start()


func toggle_disabled():
  $games_page/vbox/vbox_buttons/summon_button.disabled = !$games_page/vbox/vbox_buttons/summon_button.disabled
  $games_page/vbox/vbox_buttons/back_button.disabled = !$games_page/vbox/vbox_buttons/back_button.disabled


func get_games_selected_index():
  var games = game_list.get_children()

  # find first that is selected, toggle it, go to next index toggle it
  var selected_index = 0

  for i in len(games):
    var game = games[i]

    if game.selected:
      selected_index = i
      break

  return selected_index


func _on_selection_change_timer_timeout():
  select_next_game()
  $selection_change_timer.wait_time += 0.025
  $selection_change_timer.start()


func select_next_game():
  var games = game_list.get_children()
  var selected_index = get_games_selected_index()

  games[selected_index].toggle_select()

  selected_index += 1

  if selected_index > len(games) - 1:
    selected_index = 0

  games[selected_index].toggle_select()

  $audio_snap.play()


func _on_summon_timer_timeout():
  $selection_change_timer.stop()
  $selection_flash_timer.start()
  $start_game_timer.start()


func _on_start_game_timer_timeout():
  $selection_flash_timer.stop()
  toggle_disabled()
  start_game()


func _on_selection_flash_timer_timeout():
  var games = game_list.get_children()
  var selected_index = get_games_selected_index()

  games[selected_index].toggle_flash_color()
