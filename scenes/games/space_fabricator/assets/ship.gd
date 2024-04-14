extends StaticBody3D

var spawnPoint
var enemyRes = preload("res://scenes/games/space_fabricator/assets/alien.tscn")
var bulletRes = preload("res://scenes/games/space_fabricator/assets/pew_beam.tscn")
var enemyTarget

# Called when the node enters the scene tree for the first time.
func _ready():
  enemyTarget = get_node("fabricator")
  spawnPoint = $fabricator/spawnPoint
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass

func bullet_spawn(position, direction):
  var newBul = bulletRes.instantiate()
  $bullet_manager.add_child(newBul)
  newBul.global_transform.origin = position
  newBul.look_at(position + direction)

  pass

func _on_area_3d_area_entered(area):
  var enemy = enemyRes.instantiate()
  $enemyList.add_child(enemy)
  enemy.global_transform.origin = spawnPoint.global_transform.origin
  enemy.set_target(enemyTarget)
  spawnPoint.transform.origin.y = 2
  enemy.name = "enemy"
  pass # Replace with function body.

func despawn(body):
  body.queue_free()
