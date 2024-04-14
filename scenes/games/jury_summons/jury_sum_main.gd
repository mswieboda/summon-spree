extends Node2D

var rng = RandomNumberGenerator.new()
var jurorRemain
var jurors = []
var candidate
var playerTurn = true
var clipStat1
var clipStat2
var clipStat3
var clipStat4
var jurIndex = 0
var jurClass = preload("res://scenes/games/jury_summons/assets/juror.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():

  jurorRemain = 6

  if playerTurn == true:
    createJurorsList()
    pass

  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func newJuror():
  var j1 = jurClass.instantiate()
  return j1

  #if jurorRemain > 0:

    #pass #add new juror
  pass

func aiSelection():
  pass

func createJurorsList():
  jurors = $JuryList.get_children()
  candidate = $Candidate

func indJuror():
  if jurIndex >= 0:
    jurors[jurIndex].add_child(newJuror())
    candidate.add_child()
    jurorRemain-=1
    jurIndex+=1
