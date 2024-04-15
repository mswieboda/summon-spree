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
  spawnX = randi_range(-19,0)
  spawnZ = randi_range(-7,7)
  spawnY = 0.5
  spawnPoint.transform.origin = Vector3(spawnX,spawnY,spawnZ)


func take_damage():
  $damage_sound.play()
  health -= 2
  print(health)
  if (health <= 0 ):
    get_parent().get_parent().change_game_state(false)
