extends StaticBody3D

#spawn point Y = 2 when out of way and 0.5 when testing
var spawnX
var spawnZ
var spawnY
var health = 100
var spawnPoint

func _ready():
  spawnPoint = get_node("spawnPoint")


func _on_timer_timeout():
  spawnX = randi_range(-18,14)
  spawnZ = randi_range(-7,7)
  spawnY = 0.1
  var myOrigin = global_transform.origin
  if myOrigin.distance_to(Vector3(spawnX,spawnZ,spawnY)) < 3.0:

    return
  spawnPoint.global_transform.origin = Vector3(spawnX,spawnY,spawnZ)


func take_damage():
  $damage_sound.play()
  health -= 2
  if (health <= 0 ):
    get_parent().get_parent().change_game_state(false)
