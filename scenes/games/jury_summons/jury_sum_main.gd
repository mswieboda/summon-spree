extends Node2D

var rng = RandomNumberGenerator.new()
var jurorRemain #how many Jurors left to select
var jurors = [] #array of Juror Objects
var candidate #candidate object
var playerTurn = true #used to determine player's turn
var aiTurn = false #used to determine AI's turn
var trialCat #determines type of trial
var decisionType #used to determine Bias vs Honesty for victory
var jurIndex = 0 #index through jurors[]
var buttonAction = true #used to enable/disable buttons
var jurClass = preload("res://scenes/games/jury_summons/assets/juror.tscn")
var bTotal #total value of Bias across jurors[]
var hTotal #total value of Honesty across jurors[]


# Called when the node enters the scene tree for the first time.
func _ready():

  jurorRemain = 6 #set remaining juror's to 6
  determineTrial()
  biasVsHonesty()
  $TrialValue.set_text("Expected " + decisionType + ": " + str(randi_range(5,10)))
  createJurorsList()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if playerTurn == true:
    playerAction()

func newJuror():
  var j1 = jurClass.instantiate()

  return j1

func createJurorsList():
  jurors = $JuryList.get_children()
  candidate = $Candidate

func indJuror():
  if jurIndex >= 0 and jurIndex < 6:
    candidate.add_child(newJuror())

    $BiasValue.set_text(str(candidate.get_child(0).bias))
    $HonestyValue.set_text(str(candidate.get_child(0).honesty))
    $GenderLabel.set_text("Gender:   " + str(candidate.get_child(0).genText))
    $HairColorLabel.set_text("Hair:         " + str(candidate.get_child(0).candHairColor))
    $HeightLabel.set_text("Height:     " + str(round(candidate.get_child(0).candHeight)) + " Bananas")
    $WeightLabel.set_text("Weight:    " + str(round(candidate.get_child(0).candWeight)) + " Stone")
    #need to pull variables form instance to populate clipboard


func moveJuror():
  #print_debug(candidate.get_child(0))
  candidate.get_child(0).reparent(jurors[jurIndex],false)
  if buttonAction == true:
    pass
    #bTotal += candidate.get_child(0).bias
    #hTotal += candidate.get_child(0).honesty)
  else:
    #bTotal -= jurors[jurIndex].bias
    #hTotal -= jurors[jurIndex].honesty
    pass
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
    #print("AI Selected Yes")
  else:
    candidate.get_child(0).queue_free()
    $Timer.start(1)
    #print("AI Selected N0")

func biasVsHonesty():
  var BvsH = randi_range(1,2)

  if BvsH == 1:
    decisionType = "Bias"
  else:
    decisionType = "Honesty"

func determineTrial():
  trialCat = randi_range(1,3)

  match trialCat:
    1:
      $TrialType.set_text("Trial: Petty Theft")
    2:
      $TrialType.set_text("Trial: Murder Charge")
    3:
      $TrialType.set_text("Trial: Assault Charge")


  pass

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
  candidate.get_child(0).queue_free()
  $BiasValue.set_text("")
  $HonestyValue.set_text("")
  $NextTimer.start(1)




 # Replace with function body.


func _on_timer_timeout():
  aiAction()
  pass # Replace with function body.


func _on_next_timer_timeout():
  #play sound clip
  playerTurn = true
  pass # Replace with function body.
