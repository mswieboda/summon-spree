extends Control


var is_ready = false

func _ready():
  is_ready = true
  focus_button($title_page)


func _on_start_button_pressed():
  $title_page.hide()
  $games_page.show()
  focus_button($games_page)


func _on_exit_button_pressed():
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
    vbox_buttons.get_node("game_list").select(0)

  var control: Control = vbox_buttons.get_child(0)

  if control is Control:
    control.grab_focus()


func _on_back_button_pressed():
  $games_page.hide()
  $title_page.show()
  focus_button($title_page)


func _on_play_button_pressed():
  var game_list: ItemList = $games_page.get_node("vbox/vbox_buttons/game_list")
  var selected_game_indexes: PackedInt32Array = game_list.get_selected_items()
  var selected_game = game_list.get_item_text(selected_game_indexes[0])
  var scene = null

  if selected_game == "Minion Battle":
    scene = "res://scenes/games/minion_battle/minion_battle.tscn"
  elif selected_game == "Space Fabricator":
    scene = "res://scenes/games/space_fabricator/space_fabricator_main.tscn"
  elif selected_game == "Jury Summons":
    scene = "res://scenes/games/jury_summons/jury_sum_main.tscn"

  if scene:
    get_tree().change_scene_to_file(scene)
