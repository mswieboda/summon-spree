extends Control

signal start()
@onready var vbox_buttons = %vbox_buttons

func _ready():
  focus_button()

func _on_start_button_pressed():
  start.emit()
  hide()

func _on_exit_button_pressed():
  get_tree().quit()

func _on_visibility_changed():
  if visible:
    focus_button()

func focus_button():
  if not vbox_buttons:
    return

  var button: Button = vbox_buttons.get_child(0)

  if button is Button:
    button.grab_focus()
