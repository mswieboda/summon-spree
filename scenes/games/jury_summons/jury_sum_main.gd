extends Control

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
var bTotal = 0  #total value of Bias across jurors[]
var hTotal = 0  #total value of Honesty across jurors[]
var playComplete = false
var winValue
var BvsH
var noCountRemain
var outOfNos = false


# Called when the node enters the scene tree for the first time.
func _ready():

  jurorRemain = 6 #set remaining juror's to 6
  noCountRemain = 5
  determineTrial()
  biasVsHonesty()
  winValue = randi_range(5,10)
  $TrialValue.set_text("Expected " + decisionType + ": " + str(winValue))
  createJurorsList()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if playerTurn == true:
    playerAction()

  if playComplete == true and jurorRemain == 0:
    winCondition()
    playComplete = false
    pass

  $RRValue.set_text(str(noCountRemain))

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

  if buttonAction == true:
    bTotal = bTotal + candidate.get_child(0).bias
    hTotal = hTotal + candidate.get_child(0).honesty
  else:
    bTotal = bTotal - candidate.get_child(0).bias
    hTotal = hTotal - candidate.get_child(0).honesty

  candidate.get_child(0).reparent(jurors[jurIndex],false)
  jurIndex +=1
  jurorRemain -=1

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
    print(jurorRemain)
    if jurorRemain == 0:
      playComplete = true
    print(playComplete)
  else:
    candidate.get_child(0).queue_free()
    $Timer.start(1)
    #print("AI Selected N0")

func biasVsHonesty():
  BvsH = randi_range(1,2)

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

func winCondition():
  #print(str(BvsH) + " " + str(hTotal) + " " + str(winValue))
  $GavelEffect.play()
  if BvsH == 1:
    if bTotal > winValue:
      $game_menu.game_over(true, "Congratulations, you won the trial!")
    else:
       $game_menu.game_over(false, "Unfortunate...You lost the trial...")
  else:
    if hTotal > winValue:
       $game_menu.game_over(true, "Congratulations, you won the trial!")
    else:
       $game_menu.game_over(false, "Unfortunate...You lost the trial...")

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
  if outOfNos == true:
    return
  if noCountRemain == 1:
    outOfNos = true

  if aiTurn == false:
    noCountRemain -= 1

  candidate.get_child(0).queue_free()
  $BiasValue.set_text("")
  $HonestyValue.set_text("")
  #next
  $NextTimer.start(1)

func _on_timer_timeout():
  aiAction()
  pass # Replace with function body.

func _on_next_timer_timeout():
  #play sound clip
  playerTurn = true
  pass # Replace with function body.
