extends Node3D

var isGameOver
var isWon
var isDone

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if (isDone):
    return;
  if (isGameOver):
    if (isWon):
      $game_menu.game_over(isWon,"Help has arrived! Great job.")
      isDone = true
    else:
      print("game over called")
      $game_menu.game_over(isWon,"You have been destroyed! Game Over")
      isDone = true
  pass

func change_game_state(isWin):
  if (isDone):
    return

  print("calling game over")
  isGameOver = true
  isWon = isWin
