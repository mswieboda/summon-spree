extends StaticBody3D

var spawnPoint
var enemyRes = preload("res://scenes/games/space_fabricator/assets/alien.tscn")
var bulletRes = preload("res://scenes/games/space_fabricator/assets/pew_beam.tscn")
var enemyTarget


func _ready():
  enemyTarget = get_node("fabricator")
  spawnPoint = $fabricator/spawnPoint


func bullet_spawn(bullet_position, direction):
  var newBul = bulletRes.instantiate()
  $bullet_manager.add_child(newBul)
  newBul.global_transform.origin = bullet_position
  newBul.look_at(bullet_position + direction)


func _on_area_3d_area_entered(_area):
  var enemy = enemyRes.instantiate()
  $enemyList.add_child(enemy)
  enemy.global_transform.origin = spawnPoint.global_transform.origin
  enemy.set_target(enemyTarget)
  spawnPoint.transform.origin.y = 2
  enemy.name = "enemy"


func despawn(body):
  if body.name.contains("enemy"):
    $alien_die_sound.transform.origin = body.transform.origin
    print("play dead")
    $alien_die_sound.play()

  body.queue_free()
