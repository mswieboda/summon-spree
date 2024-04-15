extends Node3D

var isGameOver
var isWon
var isDone

var fabHP

var time_left = 120
var isTimeUp = false
var hudTimer

# Called when the node enters the scene tree for the first time.
func _ready():
  hudTimer = get_node("HUD/Time_display")
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if !isTimeUp:
    updateTime(delta)
    updateHP()
    pass



  if isDone:
    return;
  if isGameOver:
    isTimeUp = true
    if isWon:
      $game_menu.game_over(isWon, "Help has arrived! Great job.")
      isDone = true
    else:
      print("game over called")
      $game_menu.game_over(isWon, "You have been destroyed! Game Over")
      isDone = true
  pass

func updateTime(delta):
  time_left -= delta
  var minutes = int(time_left / 60)
  var seconds = time_left - (minutes * 60)
  hudTimer.text = str(minutes) +" m " + "%.1f s" % [seconds]
  if time_left <= 0:
    isGameOver = true
    isWon = true



func change_game_state(isWin):
  if isDone:
    return

  print("calling game over")
  isGameOver = true
  isWon = isWin

func updateHP():
    fabHP = get_node("ship/fabricator").health
    get_node("HUD/TextureProgressBar").value = fabHP
