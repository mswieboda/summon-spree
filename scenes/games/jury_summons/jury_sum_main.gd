extends Node2D

var rng = RandomNumberGenerator.new()
var jurorRemain
var jurors = []
var candidate
var playerTurn = true
var aiTurn = false
var clipStat1
var clipStat2
var clipStat3
var clipStat4
var jurIndex = 0
var buttonAction = true
var jurClass = preload("res://scenes/games/jury_summons/assets/juror.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():

  jurorRemain = 6
  createJurorsList()

  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if playerTurn == true:
    playerAction()





func newJuror():
  var j1 = jurClass.instantiate()
  return j1

  #if jurorRemain > 0:

    #pass #add new juror
  pass


func createJurorsList():
  jurors = $JuryList.get_children()
  candidate = $Candidate

func indJuror():
  if jurIndex >= 0 and jurIndex < 6:
    #jurors[jurIndex].add_child(newJuror())
    candidate.add_child(newJuror())
    print_debug(candidate.get_child(0))



func moveJuror():
  print_debug(candidate.get_child(0))
  candidate.get_child(0).reparent(jurors[jurIndex],false)
  jurIndex+=1
  jurorRemain-=1

func playerAction():
  indJuror()
  playerTurn = false
  buttonAction = true


func aiAction():

  indJuror()
  if randi_range(-1, 1) > 0: #1 = yes, 0 = no
    moveJuror()
    playerTurn = true
    aiTurn = false
    print("AI Selected Yes")
  else:
    candidate.get_child(0).queue_free()
    $Timer.start(1)
    print("AI Selected N0")

func _on_yes_button_pressed():
  if buttonAction == false:
    return
  moveJuror()
  buttonAction = false
  aiTurn = true
  $Timer.start(1)
  pass # Replace with function body.


func _on_no_button_pressed():
  if buttonAction == false:
    return
  indJuror()
  candidate.get_child(0).queue_free()

 # Replace with function body.


func _on_timer_timeout():
  aiAction()
  pass # Replace with function body.
