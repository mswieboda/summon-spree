extends StaticBody3D

var spawnPoint
var enemyRes = preload("res://scenes/games/space_fabricator/assets/alien.tscn")
var enemyTarget

# Called when the node enters the scene tree for the first time.
func _ready():
  enemyTarget = get_node("fabricator")
  spawnPoint = $fabricator/spawnPoint
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass


func _on_area_3d_area_entered(area):
  print("making enemy")
  var enemy = enemyRes.instantiate()
  $enemyList.add_child(enemy)
  enemy.global_transform.origin = spawnPoint.global_transform.origin
  enemy.set_target(enemyTarget)
  spawnPoint.transform.origin.y = 2
  pass # Replace with function body.
