extends Node2D

var gender #1 = male, 0 = female
var honesty
var bias
var candHeight #will be in mm
var candHairColor #switch statement for colors
var candWeight #apples

# Called when the node enters the scene tree for the first time.
func _ready():

  bias = randi_range(0,5)
  honesty = randi_range(0,5)
  candHeight = randf_range(7,12) #in Bananas
  candWeight = randf_range(6,20) #in Stone

  $Bias.set_text("B: " + str(bias))
  $Honest.set_text("H: " + str(honesty))

  if randf_range(-1, 1) > 0:
    gender = 1
    get_node("maleSprite").visible = true
    get_node("femaleSprite").visible = false
  else:
    gender = 0
    get_node("maleSprite").visible = false
    get_node("femaleSprite").visible = true




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
