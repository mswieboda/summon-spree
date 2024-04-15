extends Sprite3D


var bar_green = preload("res://scenes/games/minion_battle/assets/2d/bar_green.png")
var bar_yellow = preload("res://scenes/games/minion_battle/assets/2d/bar_yellow.png")
var bar_red = preload("res://scenes/games/minion_battle/assets/2d/bar_red.png")


func _ready():
    texture = $sub_viewport.get_texture()


func update_health(value, max_value):
    $sub_viewport/progress_bar.value = value

    if $sub_viewport/progress_bar.value < max_value:
      show()

    $sub_viewport/progress_bar.texture_progress = bar_green

    if $sub_viewport/progress_bar.value < 0.6 * max_value:
        $sub_viewport/progress_bar.texture_progress = bar_yellow
    if $sub_viewport/progress_bar.value < 0.3 * max_value:
        $sub_viewport/progress_bar.texture_progress = bar_red
