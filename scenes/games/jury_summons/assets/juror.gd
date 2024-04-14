extends Node2D

var gender #1 = male, 0 = female
var honesty
var bias

# Called when the node enters the scene tree for the first time.
func _ready():

  bias = randi_range(0,5)
  honesty = randi_range(0,5)


  if randf_range(-1, 1) > 0:
    gender = 1
    get_node("maleSprite").visible = true
    get_node("femaleSprite").visible = false
  else:
    gender = 0
    get_node("maleSprite").visible = false
    get_node("femaleSprite").visible = true

  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
