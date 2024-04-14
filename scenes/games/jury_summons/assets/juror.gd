extends Node2D

var genderVal #0 = male, 1 = female, 2 = non-binary
var genText
var honesty
var bias
var candHeight #will be in mm
var candHairColor #switch statement for colors
var candWeight #apples

# Called when the node enters the scene tree for the first time.
func _ready():

  bias = randi_range(1,5)
  honesty = randi_range(1,5)
  candHeight = randf_range(7,12) #in Bananas
  candWeight = randf_range(6,20) #in Stone
  var colorRoll = randi_range(0,4)

  $Bias.set_text("B: " + str(bias))
  $Honest.set_text("H: " + str(honesty))

  genderVal = randi_range(0,2)
  match genderVal:
    0: #male
      get_node("maleSprite").visible = true
      get_node("femaleSprite").visible = false
      get_node("nonBiSprite").visible = false
      genText = "Male"
    1: #female
      get_node("maleSprite").visible = false
      get_node("femaleSprite").visible = true
      get_node("nonBiSprite").visible = false
      genText = "Female"
    2: #non-binary
      get_node("maleSprite").visible = false
      get_node("femaleSprite").visible = false
      get_node("nonBiSprite").visible = true
      genText = "Non-Binary"

  match colorRoll:
    0:
      candHairColor = "Bald"
    1:
      candHairColor = "Blonde"
    2:
      candHairColor = "Black"
    3:
      candHairColor = "Brown"
    4:
      candHairColor = "Red"




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
