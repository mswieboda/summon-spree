extends Label

const UNSELECTED_COLOR = Color("#ffffff")
const SELECTED_COLOR = Color("#00ff00")

@export var selected = false
var flashing = false

func _ready():
  add_theme_color_override("font_color", UNSELECTED_COLOR)

  if selected:
    toggle_select()


func toggle_select():
  selected = !selected

  if has_theme_color_override("font_color"):
    remove_theme_color_override("font_color")

  add_theme_color_override("font_color", SELECTED_COLOR if selected else UNSELECTED_COLOR)

func toggle_flash_color():
  flashing = !flashing

  if has_theme_color_override("font_color"):
    remove_theme_color_override("font_color")

  add_theme_color_override("font_color", SELECTED_COLOR if flashing else UNSELECTED_COLOR)
